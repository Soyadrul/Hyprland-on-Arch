#! /usr/bin/bash

exec 9>/tmp/greyscale.lock || exit 1
flock -n 9 || exit 1

direction="${1}"
script_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
shaders_dir="$(dirname "${script_dir}")/../shaders"

current_shader=$(hyprctl getoption decoration:screen_shader | grep "str:" | sed 's/.*str: //')

if [[ "${current_shader}" == *"greyscale_100"* ]]; then
    current="100"
elif [[ "${current_shader}" == *"greyscale_50"* ]]; then
    current="50"
else
    current="0"
fi

case "${direction}" in
    forward)
        case "${current}" in
            0)  next="50"  ;;
            50) next="100" ;;
            100) next="0"  ;;
            *)  next="50"  ;;
        esac
        ;;
    backward)
        case "${current}" in
            0)  next="100" ;;
            100) next="50"  ;;
            50) next="0"   ;;
            *)  next="100" ;;
        esac
        ;;
    *)
        echo "Usage: $0 {forward|backward}" >&2
        exit 1
        ;;
esac

if [ "${next}" = "0" ]; then
    hyprctl eval 'hl.config({ decoration = { screen_shader = "" } })'
    notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/weather-clear-symbolic.svg --replace-id=1000002 "Greyscale" "Off"
else
    hyprctl eval "hl.config({ decoration = { screen_shader = \"${shaders_dir}/greyscale_${next}.glsl\" } })"
    notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/weather-clear-symbolic.svg --replace-id=1000002 "Greyscale" "${next}%"
fi
