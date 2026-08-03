#!/bin/sh
STATE_FILE="/tmp/.battery-saver-state"
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -le 15 ]; then
    if [ ! -f "$STATE_FILE" ]; then
        tlp power-saver
        touch "$STATE_FILE"
    fi
elif [ "$STATUS" = "Charging" ] || [ "$STATUS" = "Full" ]; then
    if [ -f "$STATE_FILE" ]; then
        tlp start
        rm -f "$STATE_FILE"
    fi
fi
