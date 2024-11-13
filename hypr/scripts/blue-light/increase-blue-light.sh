#! /usr/bin/bash

# Function to execute when you want to increase the blue light filter
increase_blue_light(){
    
    #array=( $(pidof hyprsunset) )
    #unset 'array[0]'
    #kill $(echo "${array[@]}")
    
    blue_light=$(cat $HOME/.config/hypr/scripts/blue-light/temperature)
    blue_light_step=$(cat $HOME/.config/hypr/scripts/blue-light/blue_light_step)
    min_blue_light=$(cat $HOME/.config/hypr/scripts/blue-light/min_blue_light)
    
    if [ $(( ${blue_light} - ${blue_light_step} )) -gt ${min_blue_light} ]
    then
        blue_light=$(( ${blue_light} - ${blue_light_step} ))
    else
        blue_light=${min_blue_light}
    fi

    echo "${blue_light}" > $HOME/.config/hypr/scripts/blue-light/temperature
    notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/night-light-symbolic.svg --replace-id=1000000 "Night light" "Blue light filter: $(echo "${blue_light}")"
    hyprsunset -t ${blue_light}
}

increase_blue_light
