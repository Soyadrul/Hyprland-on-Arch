#! /usr/bin/bash

sudo systemctl enable sddm
sudo systemctl enable NetworkManager.service
sudo systemctl enable ModemManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable tlp.service
#systemctl enable bluez

