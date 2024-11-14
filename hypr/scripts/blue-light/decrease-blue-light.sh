#! /usr/bin/bash

# Function to execute when you want to decrease the blue light filter
decrease_blue_light(){
    
    #array=( $(pidof hyprsunset) )
    #unset 'array[0]'
    #kill $(echo "${array[@]}")
    
    blue_light=$(cat $HOME/.config/hypr/scripts/blue-light/temperature)
    blue_light_step=$(cat $HOME/.config/hypr/scripts/blue-light/blue_light_step)
    max_blue_light=$(cat $HOME/.config/hypr/scripts/blue-light/max_blue_light)
    
    if [ $(( ${blue_light} + ${blue_light_step} )) -lt ${max_blue_light} ]
    then
        blue_light=$(( ${blue_light} + ${blue_light_step} ))
        echo "${blue_light}" > $HOME/.config/hypr/scripts/blue-light/temperature
        notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/night-light-symbolic.svg --replace-id=1000000 "Night light" "Blue light filter: $(echo "${blue_light}")"
        hyprsunset -t ${blue_light}
    else
        blue_light=${max_blue_light}
        echo "${blue_light}" > $HOME/.config/hypr/scripts/blue-light/temperature
        kill $(pidof hyprsunset) # To kill the old instances
        notify-send --icon=/usr/share/icons/Adwaita/symbolic/status/night-light-disabled-symbolic.svg --replace-id=1000000 "Night light" "Blue light filter turned off"
        hyprsunset -i
    fi
}

decrease_blue_light
