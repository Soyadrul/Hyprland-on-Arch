#! /usr/bin/bash

install_aur_helper() {
    # Save current stdout to File Descriptor 3, redirect stdout to stderr
    exec 3>&1
    exec 1>&2
    
    # List of AUR helpers (from input)
    local OPTIONS=("$@")
    
    # Check if another AUR helper is installed
    for helper in "${OPTIONS[@]}"; do
        if command -v "${helper}" >/dev/null 2>&1; then
            echo "${helper}" >&3
            return 0
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
    
    gum style --bold --foreground 212 "Installing AUR helper: ${AUR_helper}"
    #echo ""
    
    # Installing prerequisites
    gum spin --spinner minidot --show-output --title "Prerequisites" -- sudo pacman -S --needed --noconfirm base-devel
    if [ $? -ne 0 ]; then
        echo "Failed to install base-devel. Aborting."
        return 1
    fi
    gum style --foreground 46 "  ✓ Prerequisites installed"
    
    #gum style "  -> Downloading ${AUR_helper}"
    gum spin --spinner minidot --show-output --title "Downloading ${AUR_helper}" -- curl --silent --show-error "${Download_link}" --output "${Zip_folder_name}"
    if [ $? -ne 0 ]; then
        echo "Failed to download ${AUR_helper}. Aborting."
        return 1
    fi
    gum style --foreground 46 "  ✓ Downloaded"
    
    #gum style "  -> Extracting archive..."
    gum spin --spinner minidot --show-output --title "Extracting archive..." -- tar -xvzf "${Zip_folder_name}" &>/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to extract ${AUR_helper}. Aborting."
        return 1
    fi
    gum style --foreground 46 "  ✓ Extracted"
    
    cd "${Folder}"
    
    # The -s flag is needed to automatically download and install needed dependencies that are not present in the current machine
    gum spin --spinner minidot --show-output --title "Building package..." -- makepkg -s --nocheck
    if [ $? -ne 0 ]; then
        echo "Failed to build ${AUR_helper}. Aborting."
        return 1
    fi
    gum style --foreground 46 "  ✓ Built"
    
    File_name=$(ls | grep x86_64.pkg.tar.zst | grep -v debug)
    if [ -z "${File_name}" ]; then
        echo "No package file found after build. Aborting."
        return 1
    fi
    gum spin --spinner minidot --show-output --title "Installing ${AUR_helper}..." -- sudo pacman -U "${File_name}" --noconfirm
    if [ $? -ne 0 ]; then
        echo "Failed to install ${AUR_helper}. Aborting."
        return 1
    fi
    gum style --foreground 46 "  ✓ Installed"
    
    # Refresh bash command cache so newly installed binary is recognized
    hash -r
    
    # Verify the AUR helper is actually available
    if ! command -v "${AUR_helper}" >/dev/null 2>&1; then
        echo "WARNING: ${AUR_helper} reported as installed but binary not found. It may need to be added to PATH."
    fi
    
    #echo ""
    gum style --bold --foreground 212 "✓ AUR helper ${AUR_helper} installed successfully!"
    
    echo "${AUR_helper}" >&3
    
    exec 3>&-   # Close File Descriptor #3
}
