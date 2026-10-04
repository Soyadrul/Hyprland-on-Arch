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

# Internal panel(s) - kernel backlight class
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" set "${step}%${sign}"
fi

# External monitor(s) - DDC/CI. --skip-ddc-checks trusts the reply's invalid
# feature flag instead of probing DDC support first, saving another ~80ms/call.
for bus in "${ddc_buses[@]}"; do
    ddcutil --skip-ddc-checks --bus "${bus}" setvcp --noverify 10 "${sign}" "${step}"
done

# Report the primary device's current brightness (backlight %, else first monitor)
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" -m | awk -F',' '{print $4}'
elif [[ ${#ddc_buses[@]} -gt 0 ]]; then
    ddcutil --skip-ddc-checks --bus "${ddc_buses[0]}" --brief getvcp 10 2>/dev/null | awk '{print $4"%"}'
fi
