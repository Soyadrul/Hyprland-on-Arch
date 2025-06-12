#! /usr/bin/bash

sudo systemctl enable sddm
sudo systemctl enable NetworkManager.service
sudo systemctl enable ModemManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable cups.service
#systemctl enable bluez

# Tlp
sudo systemctl enable tlp.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
