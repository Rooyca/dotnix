#!/usr/bin/env bash

BATTERY_LEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
THRESHOLD=70
DATE=$(date)

echo -e ">>> $DATE \n" >> /tmp/battery_check

if [ "$BATTERY_LEVEL" -lt "$THRESHOLD" ]; then
    notify-send " ⚠️  Low Battery" "Battery is at: ${BATTERY_LEVEL}%"
fi
