#! /usr/bin/bash

Current_location=$(pwd)

# To ignore the lid-switch operation (it will be managed by Hyprland on hyprland.conf file)
echo -e "\nHandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf

# System upgrade
sudo pacman -Syu

# Install Paru (AUR helper)
./aur.sh

# Install the packages
./packages.sh

# Systemctl setup
./systemctl.sh

# Creating simlinks for the dotfiles
cd "${Current_location}"
./dotfiles.sh
