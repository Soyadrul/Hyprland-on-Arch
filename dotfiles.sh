#! /usr/bin/bash

Current_location=$(pwd)

# Dunst - notification daemon
target_folder="$HOME/.config/dunst/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/dunst/dunstrc "${target_folder}"dunstrc

# Kitty - terminal emulator
target_folder="$HOME/.config/kitty/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/kitty/kitty.conf "${target_folder}"kitty.conf

# Waybar - status bar
target_folder="$HOME/.config/waybar/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/waybar/config "${target_folder}"config
ln -s "${Current_location}"/waybar/style.css "${target_folder}"style.css

# Wlogout - logout manager
target_folder="$HOME/.config/wlogout/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wlogout/layout "${target_folder}"layout
ln -s "${Current_location}"/wlogout/style.css "${target_folder}"style.css

# Wofi - App launcher
target_folder="$HOME/.config/wofi/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wofi/config "${target_folder}"config
ln -s "${Current_location}"/wofi/style.css "${target_folder}"style.css

# Hyprland - window manager
target_folder="$HOME/.config/hypr/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/hypr/hyprland.conf "${target_folder}"hyprland.conf

# Wallpapers
target_folder="$HOME/.config/wallpapers/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/wallpapers/* "${target_folder}"

# .bashrc
target_folder="$HOME/"
rm $HOME/.bashrc
ln -s "${Current_location}"/bash/.bashrc "${target_folder}".bashrc

# Hyprlock - lock screen
target_folder="$HOME/.config/hypr/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/hypr/hyprlock.conf "${target_folder}"hyprlock.conf

# Hypridle - idle manager
target_folder="$HOME/.config/hypr/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/hypr/hypridle.conf "${target_folder}"hypridle.conf

# Swappy - Snapshot editing tool
target_folder="$HOME/.config/swappy/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/swappy/config "${target_folder}"config

# Neofetch
target_folder="$HOME/.config/neofetch/"
mkdir -p "${target_folder}"
rm -rf "${target_folder}config.conf"
ln -s "${Current_location}"/neofetch/config.conf "${target_folder}"config.conf
ln -s "${Current_location}"/neofetch/small.conf "${target_folder}"small.conf

# Mpv - Media player
target_folder="$HOME/.config/mpv/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/mpv/mpv.conf "${target_folder}"mpv.conf
ln -s "${Current_location}"/mpv/input.conf "${target_folder}"input.conf

# nwg-dock-hyprland - Dock
target_folder="$HOME/.config/nwg-dock-hyprland/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/nwg-dock-hyprland/style.css "${target_folder}"style.css

# SDDM - Login manager
target_folder="/etc/"
sudo ln -s "${Current_location}"/sddm/sddm.conf "${target_folder}"sddm.conf

# sugar-candy - SDDM theme
target_folder="/usr/share/sddm/themes/sugar-candy/"
sudo mv "${target_folder}"theme.conf "${target_folder}"theme.conf.old
sudo cp "${Current_location}"/sddm/sugar-candy/theme.conf "${target_folder}"theme.conf
