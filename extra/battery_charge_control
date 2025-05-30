#!/usr/bin/bash

# Battery Charge Control Script for Arch Linux
# Stops charging when battery > 85% and on AC power
# Resumes charging when battery < 25%

# Configuration
UPPER_THRESHOLD=85
LOWER_THRESHOLD=25
SLEEP_INTERVAL=30  # Check every 30 seconds
LOG_FILE="/var/log/battery-control.log"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to get battery percentage
get_battery_percentage() {
    cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1
}

# Function to check if AC adapter is connected
is_ac_connected() {
    local ac_status=$(cat /sys/class/power_supply/A{C,DP}*/online 2>/dev/null | head -n1)
    [[ "$ac_status" == "1" ]]
}

# Function to get current charging status
get_charging_status() {
    cat /sys/class/power_supply/BAT*/status 2>/dev/null | head -n1
}

# Function to stop charging
stop_charging() {
    local battery_path="/sys/class/power_supply/BAT0"
    
    # Try different methods to stop charging
    if [[ -w "$battery_path/charge_control_end_threshold" ]]; then
        echo "$UPPER_THRESHOLD" > "$battery_path/charge_control_end_threshold"
        log_message "Charging stopped using charge_control_end_threshold"
        return 0
    elif [[ -w "$battery_path/charge_stop_threshold" ]]; then
        echo "$UPPER_THRESHOLD" > "$battery_path/charge_stop_threshold"
        log_message "Charging stopped using charge_stop_threshold"
        return 0
    elif command -v tlp >/dev/null 2>&1; then
        tlp setcharge 0 1 BAT0 #tlp setcharge "$LOWER_THRESHOLD" "$UPPER_THRESHOLD" BAT0
        log_message "Charging controlled using TLP"
        return 0
#    elif [[ -w "/proc/acpi/call" ]]; then
#        # ThinkPad specific method
#        echo '\_SB.PCI0.LPC.EC.HKEY.CHGS 0' > /proc/acpi/call
#        log_message "Charging stopped using ACPI call (ThinkPad)"
#        return 0
    else
        log_message "ERROR: No supported method found to control charging"
        return 1
    fi
}

# Function to start charging
start_charging() {
    local battery_path="/sys/class/power_supply/BAT0"
    
    # Try different methods to resume charging
    if [[ -w "$battery_path/charge_control_end_threshold" ]]; then
        echo "100" > "$battery_path/charge_control_end_threshold"
        log_message "Charging resumed using charge_control_end_threshold"
        return 0
    elif [[ -w "$battery_path/charge_stop_threshold" ]]; then
        echo "100" > "$battery_path/charge_stop_threshold"
        log_message "Charging resumed using charge_stop_threshold"
        return 0
    elif command -v tlp >/dev/null 2>&1; then
        tlp fullcharge BAT0 #tlp setcharge 0 100 BAT0
        log_message "Charging resumed using TLP"
        return 0
#    elif [[ -w "/proc/acpi/call" ]]; then
#        # ThinkPad specific method
#        echo '\_SB.PCI0.LPC.EC.HKEY.CHGS 1' > /proc/acpi/call
#        log_message "Charging resumed using ACPI call (ThinkPad)"
#        return 0
    else
        log_message "ERROR: No supported method found to control charging"
        return 1
    fi
}

# Function to send desktop notification
send_notification() {
    local message="$1"
    local urgency="${2:-normal}"
    
    # Try to find the user running Hyprland
    local hyprland_user=$(pgrep -u "$(id -u)" Hyprland 2>/dev/null | head -n1)
    if [[ -n "$hyprland_user" ]]; then
        # Send notification if notify-send is available
        if command -v notify-send >/dev/null 2>&1; then
            DISPLAY=:0 notify-send -u "$urgency" "Battery Control" "$message"
        fi
    fi
    
    log_message "$message"
}

# Check if running as root (required for most charging control methods)
if [[ $EUID -ne 0 ]]; then
    echo "This script requires root privileges to control charging."
    echo "Please run with sudo: sudo $0"
    exit 1
fi

# Main loop
log_message "Battery control script started (Upper: ${UPPER_THRESHOLD}%, Lower: ${LOWER_THRESHOLD}%)"
send_notification "Battery control script started"
tlp setcharge 0 0 BAT0
charging_stopped=false

while true; do
    battery_level=$(get_battery_percentage)
    charging_status=$(get_charging_status)
    
    if [[ -z "$battery_level" ]]; then
        log_message "ERROR: Could not read battery level"
        sleep "$SLEEP_INTERVAL"
        continue
    fi
    
    if is_ac_connected; then
        if [[ "$battery_level" -ge "$UPPER_THRESHOLD" ]] && [[ "$charging_stopped" == false ]]; then
            if stop_charging; then
                charging_stopped=true
                send_notification "Charging stopped at ${battery_level}% to preserve battery health" "normal"
            fi
        #elif [[ "$battery_level" -le "$LOWER_THRESHOLD" ]] && [[ "$charging_stopped" == true ]]; then
        #    if start_charging; then
        #        charging_stopped=false
        #        send_notification "Charging resumed at ${battery_level}%" "normal"
        #    fi
        fi
    else
        # AC disconnected, reset state
        if [[ "$charging_stopped" == true ]]; then
            charging_stopped=false
            tlp setcharge 0 0 BAT0
            log_message "AC disconnected, resetting charging state"
        fi
    fi
    
    # Debug output every 5 minutes (10 cycles of 30 seconds)
    if [[ $(($(date +%s) % 300)) -lt 30 ]]; then
        log_message "Status: Battery ${battery_level}%, AC $(is_ac_connected && echo "connected" || echo "disconnected"), Charging $(echo "$charging_status"), Control $(echo "$charging_stopped" | tr 'tf' 'TF')"
    fi
    
    sleep "$SLEEP_INTERVAL"
done
