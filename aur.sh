#! /usr/bin/bash

# Variables
Paru_download_link="https://aur.archlinux.org/cgit/aur.git/snapshot/paru-bin.tar.gz"
Paru_zip_folder_name="paru-bin.tar.gz"
Paru_folder="paru-bin/"

mkdir -p $HOME/Downloads/
cd $HOME/Downloads/

download_process=$(curl "${Paru_download_link}" --output "${Paru_zip_folder_name}")
wait ${download_process}

tar -xvzf "${Paru_zip_folder_name}"

cd "${Paru_folder}"

# The -s flag is needed to automatically download and install needed dependencies that are not present in the current machine
makepkg -s

Paru_file_name=$(ls | grep x86_64.pkg.tar.zst | grep -v debug)
sudo pacman -U "${Paru_file_name}"
