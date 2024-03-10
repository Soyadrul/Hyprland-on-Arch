#! /usr/bin/bash

# Variables
Paru_download_link="https://aur.archlinux.org/cgit/aur.git/snapshot/paru.tar.gz"
Paru_zip_folder_name="paru.tar.gz"
Paru_folder="paru/"

mkdir -p $HOME/Downloads/
cd $HOME/Downloads/

download_process=$(curl "${Paru_download_link}" --output "${Paru_zip_folder_name}")
wait ${download_process}

tar -xvzf "${Paru_zip_folder_name}"

cd "${Paru_folder}"

makepkg -s

Paru_file_name=$(ls | grep x86_64.pkg.tar.zst | grep -v debug)
sudo pacman -U "${Paru_file_name}"