#! /usr/bin/bash

Current_location=$(pwd)

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
