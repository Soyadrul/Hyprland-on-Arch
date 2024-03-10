#! /usr/bin/bash

systemctl enable sddm
systemctl enable NetworkManager.service
systemctl enable ModemManager.service
systemctl enable bluetooth.service
#systemctl enable bluez

