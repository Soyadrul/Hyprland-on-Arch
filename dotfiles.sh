#! /usr/bin/bash

Current_location=$(pwd)

# Dunst - notification daemon
target_folder="$HOME/.config/dunst/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/dunst/* "${target_folder}"

# Kitty - terminal emulator
target_folder="$HOME/.config/kitty/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/kitty/* "${target_folder}"

# Waybar - status bar
target_folder="$HOME/.config/waybar/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/waybar/* "${target_folder}"

# Wlogout - logout manager
target_folder="$HOME/.config/wlogout/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wlogout/* "${target_folder}"

# Wofi - App launcher
target_folder="$HOME/.config/wofi/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wofi/* "${target_folder}"

# Hyprland - window manager
target_folder="$HOME/.config/hypr/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/hypr/* "${target_folder}"

# Wallpapers
target_folder="$HOME/.config/wallpapers/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wallpapers/* "${target_folder}"

# .bashrc
target_folder="$HOME/"
rm $HOME/.bashrc
ln -s "${Current_location}"/bash/.bashrc "${target_folder}".bashrc

# Swappy - Snapshot editing tool
target_folder="$HOME/.config/swappy/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/swappy/* "${target_folder}"

# Neofetch
target_folder="$HOME/.config/neofetch/"
mkdir -p "${target_folder}"
rm -rf "${target_folder}config.conf"
ln -s "${Current_location}"/neofetch/* "${target_folder}"

# Mpv - Media player
target_folder="$HOME/.config/mpv/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/mpv/* "${target_folder}"

# nwg-dock-hyprland - Dock
target_folder="$HOME/.config/nwg-dock-hyprland/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/nwg-dock-hyprland/* "${target_folder}"

# SDDM - Login manager
target_folder="/etc/"
sudo ln -s "${Current_location}"/sddm/sddm.conf "${target_folder}"sddm.conf

# sugar-candy - SDDM theme
target_folder="/usr/share/sddm/themes/sugar-candy/"
sudo mv "${target_folder}"theme.conf "${target_folder}"theme.conf.old
sudo cp "${Current_location}"/sddm/sugar-candy/theme.conf "${target_folder}"theme.conf
