#! /usr/bin/bash

# Utilities
pacman="git nano neofetch firefox vlc ffmpeg htop gtk2 gtk3 gtk4 mpv mpv-mpris powertop qt5-wayland qt6-wayland gnome-themes-extra nwg-look nwg-displays zram-generator man-pages-it libva-utils vdpauinfo lib32-libva-vdpau-driver libvdpau-va-gl resources thunderbird libreoffice-still python-pip fzf bc arp-scan imagemagick "
#libva-vdpau-driver
#mpd
aur="localsend-bin parabolic-gtk downgrade dotool zen-browser-bin "
#archlinux-tweak-tool-git python-spotdl

# Fun
pacman+="cmatrix sl cowsay figlet "

# Hardware video acceleration
vendor_id=$(grep -m1 'vendor_id' /proc/cpuinfo | awk '{print $3}')
AMD_vendor_id="AuthenticAMD"
Intel_vendor_id="GenuineIntel"
# AMD
if [[ "${vendor_id}" == "${AMD_vendor_id}" ]]; then
	pacman+="radeontop mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon "
# Intel
elif [[ "${vendor_id}" == "${Intel_vendor_id}" ]]; then
	pacman+="intel-gpu-tools intel-media-driver libva-intel-driver lib32-libva-intel-driver mesa lib32-mesa vulkan-intel lib32-vulkan-intel linux-firmware "
# Unknown CPU
else
	echo "Unknown CPU vendor"
	#libva-nvidia-driver nvidia-utils libvdpau lib32-libvdpau
	#libva lib32-libva libva-utils libvarlink
fi


# Hyprland & co
pacman+="hyprland hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprlock hypridle hyprcursor nwg-dock-hyprland hyprpicker hyprland-qtutils hyprsunset "
#aur+="hyprshade "

# Fonts
pacman+="otf-font-awesome ttf-roboto ttf-roboto-mono ttf-roboto-mono-nerd ttf-jetbrains-mono-nerd noto-fonts-cjk "

# Bluetooth
pacman+="bluez bluez-utils blueman "

# Network
pacman+="networkmanager nm-connection-editor modemmanager usb_modeswitch network-manager-applet "

# Notifications
pacman+="dunst libnotify "

# Clipboard manager
pacman+="cliphist wl-clipboard wl-clip-persist "

# Audio
pacman+="wireplumber pipewire pamixer "

# Brightness
pacman+="brightnessctl "

# Terminal emulator
pacman+="kitty "

# File manager
pacman+="nautilus sushi nautilus-image-converter "
aur+="nautilus-open-any-terminal "

# Cloud app - Mega
#aur+="megasync-bin nautilus-megasync "

# Authentication agent
pacman+="hyprpolkitagent "
#polkit-kde-agent polkit-gnome

# Login manager
pacman+="sddm "
aur+="sddm-sugar-candy-git "

# Sway window manager utilities
#sudo pacman -S swayidle
#aur -S swaylock-effects

# Status bar
pacman+="waybar "

# Logout menu
aur+="wlogout "

# App launcher
pacman+="wofi "

# To make and edit screenshots
pacman+="grim slurp swappy "

# A redshift alternative for Wayland wlroots compositors
#sudo pacman -S gammastep

# Tool to choose CPU power mode (powersave/performance)
pacman+="tlp "
#sudo pacman -S power-profiles-daemon
#aur -S auto-cpufreq

# To make and use virtual machines
pacman+="qemu-full "
aur+="quickemu "

# Gnome packages
pacman+="gnome-calculator gnome-clocks gnome-text-editor gnome-weather gnome-disk-utility evince eog cheese simple-scan snapshot "
#gnome-system-monitor gnome-tweaks

# Markdown editor
pacman+="apostrophe "

# Printer support
pacman+="cups cups-pdf bluez-cups cups-browsed system-config-printer hplip "
#cups-pk-helper

# Package used to display the keys pressed on Wayland
pacman+="wev "

# Cursor theme
aur+="bibata-cursor-theme "


# Downloading the packages
sudo pacman -S ${pacman}
paru -S ${aur}

# Add "Open with kitty" button on nautilus file manager
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system
