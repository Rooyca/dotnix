#!/bin/bash

# Display a menu using whiptail
CHOICE=$(whiptail --title "System Menu" --menu "Choose an option" 15 60 4 \
"P" "Power Off" \
"R" "Reboot" \
"L" "Logout" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus != 0 ]; then
    echo "Exit."
    exit 1
fi

# Perform the selected action
case $CHOICE in
    P)
        whiptail --yesno "Are you sure you want to power off?" 10 60
        if [ $? -eq 0 ]; then
            loginctl poweroff
        fi
        ;;
    R)
        whiptail --yesno "Are you sure you want to reboot?" 10 60
        if [ $? -eq 0 ]; then
            loginctl reboot
        fi
        ;;
    L)
        whiptail --yesno "Are you sure you want to log out?" 10 60
        if [ $? -eq 0 ]; then
            loginctl terminate-user $USER
        fi
        ;;
esac