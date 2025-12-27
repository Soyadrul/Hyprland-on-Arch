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
    
    gum style --bold --foreground 212 "Installing AUR helper: ${AUR_helper}" >&2
    #echo "" >&2
    
    #gum style "  -> Downloading ${AUR_helper}" >&2
    gum spin --spinner minidot --show-output --title "Downloading ${AUR_helper}" -- curl --silent --show-error "${Download_link}" --output "${Zip_folder_name}"
    gum style --foreground 46 "  ✓ Downloaded" >&2
    
    #gum style "  -> Extracting archive..." >&2
    gum spin --spinner minidot --show-output --title "Extracting archive..." -- tar -xvzf "${Zip_folder_name}" &>/dev/null
    gum style --foreground 46 "  ✓ Extracted" >&2
    
    cd "${Folder}"
    
    # The -s flag is needed to automatically download and install needed dependencies that are not present in the current machine
    gum spin --spinner minidot --show-output --title "Building package..." -- makepkg -s
    gum style --foreground 46 "  ✓ Built" >&2
    
    File_name=$(ls | grep x86_64.pkg.tar.zst | grep -v debug)
    gum spin --spinner minidot --show-output --title "Installing ${AUR_helper}..." -- sudo pacman -U "${File_name}" --noconfirm
    gum style --foreground 46 "  ✓ Installed" >&2
    
    #echo "" >&2
    gum style --bold --foreground 212 "✓ AUR helper ${AUR_helper} installed successfully!" >&2
    
    echo "${AUR_helper}"
}
