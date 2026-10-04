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
cache_file="${XDG_RUNTIME_DIR:-/tmp}/brightness-ddc-displays"
fingerprint=$(for c in /sys/class/drm/card*-*; do [[ -e "$c/status" ]] && echo "$c $(<"$c/status")"; done | sort | tr '\n' ';')

if [[ ! -f "${cache_file}" || "$(head -n1 "${cache_file}")" != "${fingerprint}" ]]; then
    {
        echo "${fingerprint}"
        ddcutil detect 2>/dev/null | grep "^Display" | awk '{print $2}'
    } > "${cache_file}"
fi

mapfile -t ddc_displays < <(tail -n +2 "${cache_file}")

# Internal panel(s) - kernel backlight class
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" set "${step}%${sign}"
fi

# External monitor(s) - DDC/CI
for display_num in "${ddc_displays[@]}"; do
    ddcutil --display "${display_num}" setvcp --noverify 10 "${sign}" "${step}"
done

# Report the primary device's current brightness (backlight %, else first monitor)
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" -m | awk -F',' '{print $4}'
elif [[ ${#ddc_displays[@]} -gt 0 ]]; then
    ddcutil --display 1 --brief getvcp 10 2>/dev/null | awk '{print $4"%"}'
fi
