#!/usr/bin/bash

# Save the script
sudo cp extra/battery-control.sh /usr/local/bin/battery-control.sh
sudo chmod +x /usr/local/bin/battery-control.sh

# Install the systemd service
sudo cp extra/battery-control.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable battery-control.service
sudo systemctl start battery-control.service
