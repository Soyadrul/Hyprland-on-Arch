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

# Swaylock effects
target_folder="$HOME/.swaylock/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/swaylock/config "${target_folder}"config

# Swappy - Snapshot editing tool
target_folder="$HOME/.config/swappy/"
mkdir -p "${target_folder}"
ln -s "${Current_location}"/swappy/config "${target_folder}"config
