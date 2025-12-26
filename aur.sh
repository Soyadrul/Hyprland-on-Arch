#! /usr/bin/bash

install_aur_helper() {
	
	# List of AUR helpers (from input)
	local OPTIONS=("$@")
	
	# Check if another AUR helper is installed
	for helper in "${OPTIONS[@]}"; do
		if command -v "${helper}" >/dev/null 2>&1; then
			echo "${helper}"
			exit 0 # Exits the bash script with success code if an AUR helper is already installed
		fi
	done
	
	# Choose the AUR helper
	local CHOICE=$(gum choose --limit 1 "${OPTIONS[@]}")
	
	# Defaulting to yay AUR helper if no option chosen
	if [ -z "${CHOICE}" ]; then
		CHOICE="yay"
	fi
	
	# Variables
	local AUR_helper="${CHOICE}"
	local Download_link="https://aur.archlinux.org/cgit/aur.git/snapshot/${AUR_helper}-bin.tar.gz"
	local Zip_folder_name="${AUR_helper}-bin.tar.gz"
	local Folder="${AUR_helper}-bin/"

	mkdir -p $HOME/Downloads/
	cd $HOME/Downloads/

	local download_process=$(curl "${Download_link}" --output "${Zip_folder_name}")
	wait ${download_process}

	tar -xvzf "${Zip_folder_name}"

	cd "${Folder}"

	# The -s flag is needed to automatically download and install needed dependencies that are not present in the current machine
	makepkg -s

	File_name=$(ls | grep x86_64.pkg.tar.zst | grep -v debug)
	sudo pacman -U "${File_name}" --noconfirm
	
	echo "${AUR_helper}"
}
