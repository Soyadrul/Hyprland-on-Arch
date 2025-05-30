#!/usr/bin/bash

# Save the script
sudo cp extra/battery_charge_control /usr/local/bin/battery_charge_control
sudo chmod +x /usr/local/bin/battery_charge_control

# Install the systemd service
sudo cp extra/battery_charge_control.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable battery_charge_control.service
