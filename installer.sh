#! /usr/bin/bash

source aur.sh
source packages.sh

Current_location=$(pwd)

# To ignore the lid-switch operation (it will be managed by Hyprland on hyprland.conf file)
grep -F "\nHandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore" /etc/systemd/logind.conf || echo -e "\nHandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf

# System upgrade
sudo pacman -Syu --noconfirm

# Install Paru (AUR helper)
#AUR_helpers=("yay" "paru" "pikaur" "pakku" "pacaur")
AUR_helpers=("yay" "paru")
AUR_helper_installed=$(install_aur_helper "${AUR_helpers[@]}")

# Install the packages
#bash packages.sh
install_packages "${AUR_helper_installed}"
# Add current user to input group, so the dotool utility becomes usable
sudo usermod -a -G input $USER

# Systemctl setup
bash systemctl.sh

# Creating simlinks for the dotfiles
cd "${Current_location}"
bash dotfiles.sh
