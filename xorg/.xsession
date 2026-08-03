#!/bin/bash

# Log start
echo "$(date): Starting .xprofile" >> /tmp/xprofile.log

# Set variables early
export QT_QPA_PLATFORMTHEME=qt5ct

# Mouse setup - run only if device exists
DEVICE="$(xinput list --name-only | grep -i 'Wired Mouse')"
if [ -n "$DEVICE" ]; then
    xinput set-prop "$DEVICE" "libinput Accel Profile Enabled" 0, 1 &
    xinput set-prop "$DEVICE" "libinput Accel Speed" 1 &
    echo "Mouse configured: $DEVICE" >> /tmp/xprofile.log
else
    echo "WARNING: Wired Mouse not found" >> /tmp/xprofile.log
fi

# Start programs one by one with error logging
if [ -f "$HOME/.fehbg" ]; then
    $HOME/.fehbg &
    echo "fehbg started" >> /tmp/xprofile.log
else
    echo "ERROR: .fehbg not found" >> /tmp/xprofile.log
fi

dunst &
echo "dunst started with PID $!" >> /tmp/xprofile.log

picom -b  # Use daemon mode instead of &
echo "picom started" >> /tmp/xprofile.log

barli 2>> /tmp/barli.log &
echo "barli started with PID $!" >> /tmp/xprofile.log

nm-applet &
echo "nm-applet started with PID $!" >> /tmp/xprofile.log

echo "$(date): .xprofile finished" >> /tmp/xprofile.log

