#!/usr/bin/env bash
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

#picom -f & # compositor
#feh --bg-fill "/home/rooyca/Pictures/15.jpg" &
#flameshot & # screenshot
dunst & # notification
nitrogen --restore & # wallpaper
nm-applet & # NetworkManager Applet
remind -z -k"notify-send 'Reminder' '%s' -u critical" ~/.reminders/primary.rem &