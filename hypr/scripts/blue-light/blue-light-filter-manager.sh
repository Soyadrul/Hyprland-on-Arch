#! /usr/bin/bash

# Initial blue light filter
initial_blue_light_setup(){
    blue_light=3200
    echo "${blue_light}" > $HOME/.config/hypr/scripts/blue-light/temperature
    notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/night-light-symbolic.svg --replace-id=1000000 "Night light" "Blue light filter turned on $(echo "${blue_light}")"
    hyprctl hyprsunset temperature ${blue_light}
}

initial_blue_light_setup
