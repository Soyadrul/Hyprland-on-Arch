#! /usr/bin/bash

direction="${1}"
step="${2:-2}"

usage() {
    echo "Usage: $0 {up|down} [step]" >&2
    exit 1
}

case "${direction}" in
    up)   sign="+" ;;
    down) sign="-" ;;
    *)    usage ;;
esac

backlight_dev=$(ls /sys/class/backlight/ 2>/dev/null | head -1)

# DDC/CI display list. `ddcutil detect` costs ~400ms of I2C traffic, so cache the
# result and only re-detect when the DRM connector topology changes (hotplug).
# Cache I2C bus numbers, not display numbers: `ddcutil --display N` re-runs
# detection internally (~400ms per call); `--bus N` addresses the bus directly.
cache_file="${XDG_RUNTIME_DIR:-/tmp}/brightness-ddc-buses"
fingerprint=$(for c in /sys/class/drm/card*-*; do [[ -e "$c/status" ]] && echo "$c $(<"$c/status")"; done | sort | tr '\n' ';')
# An empty detect result may mean no DDC-capable display, or a transient failure;
# retry it at most this often so a bad detect can't poison the cache for good.
retry_interval=5

need_detect=0
ddc_buses=()
if [[ ! -f "${cache_file}" || "$(head -n1 "${cache_file}")" != "${fingerprint}" ]]; then
    need_detect=1
else
    mapfile -t ddc_buses < <(tail -n +2 "${cache_file}")
    # Driver reloads can renumber I2C buses; don't write to a vanished one.
    for bus in "${ddc_buses[@]}"; do
        [[ -e "/dev/i2c-${bus}" ]] || { need_detect=1; break; }
    done
    if [[ ${need_detect} -eq 0 && ${#ddc_buses[@]} -eq 0 ]]; then
        now=$(date +%s)
        mtime=$(stat -c %Y "${cache_file}" 2>/dev/null || echo 0)
        (( now - mtime >= retry_interval )) && need_detect=1
    fi
fi

if (( need_detect )); then
    tmp_file="${cache_file}.tmp.$$"
    {
        echo "${fingerprint}"
        ddcutil detect 2>/dev/null | sed -n 's|.*I2C bus:.*/dev/i2c-\([0-9]\+\).*|\1|p'
    } > "${tmp_file}" && mv -f "${tmp_file}" "${cache_file}" || rm -f "${tmp_file}"
    mapfile -t ddc_buses < <(tail -n +2 "${cache_file}")
fi

# DDC/CI Set VCP Feature packet, byte-for-byte what `ddcutil setvcp` sends
# (verified against `ddcutil --trace I2C`): 51 84 03 10 <hi> <lo> <ck> to I2C
# address 0x37. 0x51 = host source address, 0x84 = 4 data bytes, 0x03 = Set VCP,
# 0x10 = brightness; the checksum is the XOR of the I2C write address byte
# (0x37 << 1 = 0x6e) and every data byte. `ddcutil setvcp` always sleeps 50ms
# after a write - hard-coded, ignores --sleep-multiplier/--disable-dynamic-sleep
# - while `i2cset` sends the same packet in ~1ms.
ddc_raw_set() {
    local bus="${1}" value="${2}" hi lo checksum
    hi=$(( (value >> 8) & 0xFF ))
    lo=$(( value & 0xFF ))
    checksum=$(( 0x6E ^ 0x51 ^ 0x84 ^ 0x03 ^ 0x10 ^ hi ^ lo ))
    i2cset -y "${bus}" 0x37 0x51 0x84 0x03 0x10 "${hi}" "${lo}" "${checksum}" i
}

# This monitor's VCP 10 read can lag its own writes by seconds, so computing every
# step from a fresh read makes rapid taps write the same target over and over
# and lose steps. Keep a per-bus state of the last value we successfully wrote
# and accumulate against that; re-read the monitor only when the state is
# missing or older than ddc_state_resync_after seconds, so changes made with the
# monitor's own OSD are still picked up. A per-bus flock serializes concurrent
# runs (key repeat) so they cannot lose increments either.
ddc_state_resync_after=15

ddc_fallback() {
    local bus="${1}"
    ddcutil --skip-ddc-checks --bus "${bus}" setvcp --noverify 10 "${sign}" "${step}"
    ddcutil --skip-ddc-checks --bus "${bus}" --brief getvcp 10 2>/dev/null | awk '{print $4}'
}

ddc_adjust() {
    local bus="${1}" state_file lock_file out cur max=100 state_val state_time target read_max
    state_file="${XDG_RUNTIME_DIR:-/tmp}/brightness-ddc-state-${bus}"
    lock_file="${state_file}.lock"

    exec 9>"${lock_file}" || { ddc_fallback "${bus}"; return; }
    flock -w 2 9 || { ddc_fallback "${bus}"; return; }

    read -r state_val state_time max < "${state_file}" 2>/dev/null
    [[ "${max}" =~ ^[0-9]+$ ]] || max=100
    if [[ "${state_val}" =~ ^[0-9]+$ && "${state_time}" =~ ^[0-9]+$ ]] &&
        (( $(date +%s) - state_time < ddc_state_resync_after )); then
        cur="${state_val}"
    elif out=$(ddcutil --skip-ddc-checks --bus "${bus}" --brief getvcp 10 2>/dev/null); then
        cur=$(awk '{print $4}' <<<"${out}")
        read_max=$(awk '{print $5}' <<<"${out}")
        [[ "${read_max}" =~ ^[0-9]+$ ]] && max="${read_max}"
    fi
    [[ "${cur}" =~ ^[0-9]+$ ]] || { ddc_fallback "${bus}"; return; }

    if [[ "${sign}" == "-" ]]; then
        target=$(( cur - step ))
    else
        target=$(( cur + step ))
    fi
    (( target < 0 )) && target=0
    (( target > max )) && target=${max}

    if command -v i2cset >/dev/null 2>&1 && ddc_raw_set "${bus}" "${target}" 2>/dev/null; then
        echo "${target} $(date +%s) ${max}" > "${state_file}"
    elif ddcutil --skip-ddc-checks --bus "${bus}" setvcp --noverify 10 "${target}" >/dev/null 2>&1; then
        echo "${target} $(date +%s) ${max}" > "${state_file}"
    fi
    echo "${target}"
    exec 9>&-
}

# Internal panel(s) - kernel backlight class
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" set "${step}%${sign}"
fi

# External monitor(s) - DDC/CI. Each bus is independent, so they are adjusted in
# parallel; each monitor's resulting value is kept for the report below.
ddc_value_file=""
ddc_primary_value=""
if [[ ${#ddc_buses[@]} -gt 0 ]]; then
    if ddc_tmpdir=$(mktemp -d "${XDG_RUNTIME_DIR:-/tmp}/brightness-ddc.XXXXXX"); then
        trap 'rm -rf "${ddc_tmpdir}"' EXIT
        for i in "${!ddc_buses[@]}"; do
            ddc_adjust "${ddc_buses[i]}" > "${ddc_tmpdir}/${i}" 2>/dev/null &
        done
        wait
        ddc_value_file="${ddc_tmpdir}/0"
    else
        # mktemp failure should be impossible here; sequential still works.
        ddc_primary_value=$(ddc_adjust "${ddc_buses[0]}" 2>/dev/null)
        for bus in "${ddc_buses[@]:1}"; do
            ddc_adjust "${bus}" >/dev/null 2>&1 &
        done
        wait
    fi
fi

# Report the primary device's current brightness (backlight %, else first monitor)
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" -m | awk -F',' '{print $4}'
elif [[ -n "${ddc_value_file}" && -s "${ddc_value_file}" ]]; then
    awk '{print $1"%"}' "${ddc_value_file}"
elif [[ -n "${ddc_primary_value}" ]]; then
    printf '%s%%\n' "${ddc_primary_value}"
fi
