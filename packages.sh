#! /usr/bin/bash

# Utilities
sudo pacman -S git nano neofetch cmatrix telegram-desktop firefox vlc ffmpeg htop gtk2 gtk3 gtk4 mpv mpv-mpris powertop qt5-wayland qt6-wayland wireplumber pipewire gnome-themes-extra nwg-look zram-generator man-pages-it libva-mesa-driver mesa-vdpau radeontop libva-utils vdpauinfo intel-media-driver libva-intel-driver flatpak
paru -S localsend-bin parabolic nwg-displays downgrade balena-etcher dotool zen-browser-avx2-bin
#sudo pacman -S mpd intel-gpu-tools
#paru -S archlinux-tweak-tool-git python-spotdl

# Hyprland & co
sudo pacman -S hyprland hyprpaper xdg-desktop-portal-hyprland hyprlock hypridle hyprcursor
paru -S hyprpicker hyprshade

# Fonts
sudo pacman -S otf-font-awesome ttf-roboto ttf-roboto-mono ttf-roboto-mono-nerd noto-fonts-cjk

# Bluetooth
sudo pacman -S bluez bluez-utils blueman

# Network
sudo pacman -S networkmanager nm-connection-editor modemmanager usb_modeswitch network-manager-applet

# Notifications
sudo pacman -S dunst libnotify

# Clipboard manager
sudo pacman -S cliphist wl-clipboard
paru -S wl-clip-persist-git

# Audio
sudo pacman -S pamixer

# Brightness
sudo pacman -S brightnessctl

# Terminal emulator
sudo pacman -S kitty

# File manager
sudo pacman -S nautilus sushi nautilus-image-converter

# Authentication agent
sudo pacman -S polkit-kde-agent

# Login manager
sudo pacman -S sddm
paru -S sddm-sugar-candy-git

# Sway window manager utilities
#sudo pacman -S swayidle
#paru -S swaylock-effects

# Status bar
sudo pacman -S waybar

# Logout menu
paru -S wlogout

# App launcher
sudo pacman -S wofi

# To make and edit screenshots
sudo pacman -S grim slurp swappy

# A redshift alternative for Wayland wlroots compositors
#sudo pacman -S gammastep

# Tool to choose CPU power mode (powersave/performance)
sudo pacman -S tlp
#paru -S auto-cpufreq

# To make and use virtual machines
sudo pacman -S qemu-full
paru -S quickemu

# Gnome packages
sudo pacman -S gnome-calculator gnome-clocks gnome-text-editor gnome-system-monitor gnome-weather gnome-disk-utility evince

# Printer support
sudo pacman -S cups cups-pdf bluez-cups cups-browsed system-config-printer hplip
#sudo pacman -S cups-pk-helper
