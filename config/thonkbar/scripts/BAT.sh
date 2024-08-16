#!/bin/bash

battery_info=$(acpi -b)
battery_percentage=$(echo "$battery_info" | grep -P -o '[0-9]+(?=%)')
battery_status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

# Display battery status
if [ "$battery_status" = "Discharging" ]; then
    echo "BAT: $battery_percentage% "
    if [ $battery_percentage -le 20 ]; then
        echo "#f71e30"
    fi
else
    echo "CHA: $battery_percentage% " 
    echo "#34eb5e"
fi

# Notification logic
if [ "$battery_status" = "Discharging" ]; then
    if [ "$battery_percentage" -lt 10 ]; then
        [ ! -f /tmp/battery_warning ] && notify-send "Battery Low" "Battery below 10%" -u critical && touch /tmp/battery_warning
    elif [ "$battery_percentage" -lt 20 ]; then
        [ ! -f /tmp/battery_notification ] && notify-send "Battery Low" "Battery below 20%" -u normal && touch /tmp/battery_notification
    else
        rm -f /tmp/battery_notification /tmp/battery_warning
    fi
else
    rm -f /tmp/battery_notification /tmp.battery_warning
    if [ "$battery_percentage" -ge 98 ]; then
        [ ! -f /tmp/battery_full ] && notify-send "Battery Full" "Battery at 98%" -u normal && touch /tmp/battery_full
    else
        rm -f /tmp/battery_full
    fi
fi