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
ddc_displays=$(ddcutil detect 2>/dev/null | grep -c "^Display")

# Internal panel(s) - kernel backlight class
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" set "${step}%${sign}"
fi

# External monitor(s) - DDC/CI
if [[ "${ddc_displays}" -gt 0 ]]; then
    while read -r display; do
        display_num=$(echo "${display}" | awk '{print $2}')
        ddcutil --display "${display_num}" setvcp --noverify 10 "${sign}" "${step}"
    done < <(ddcutil detect 2>/dev/null | grep "^Display")
fi

# Report the primary device's current brightness (backlight %, else first monitor)
if [[ -n "${backlight_dev}" ]]; then
    brightnessctl -d "${backlight_dev}" -m | awk -F',' '{print $4}'
elif [[ "${ddc_displays}" -gt 0 ]]; then
    ddcutil --display 1 --brief getvcp 10 2>/dev/null | awk '{print $4"%"}'
fi
