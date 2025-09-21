#!/bin/bash

cd $(dirname -- $0)

. ./common.sh

fifo=${XDG_RUNTIME_DIR:-/tmp}/lemonbar.fifo
test -e $fifo && rm $fifo
mkfifo $fifo

trap 'pkill lemonbar; kill $(jobs -p)' EXIT

# Date
while :; do
	date "+DAT%a %d %b %Y, %I:%M %p" > $fifo
    sleep 1;
done &

# BSPWM desktops
while read -r line; do
    echo "DES$(bspc_desktops)" > $fifo
done < <(bspc subscribe desktop) &

# Brightness
while :; do
    echo "BRI$(brightnessctl | grep -oP '\(\d+%\)' | tr -d '()%')%" > $fifo
    sleep 5
done &

# Volume
while :; do
    current=$(pactl list sinks | awk '/\tVolume/ {print $5}')
    current_n=$(cut -d'%' -f1 <<< $current)

    if [[ "$(pactl list sinks | awk '/Mute:/ {print $2}')" == "yes" ]]; then
        icon="\ufa80"
    elif [ $current_n -gt 50 ]; then
        icon="\ufa7d"
    elif [ $current_n -gt 25 ]; then
        icon="\ufa7f"
    else
        icon="\ufa7e"
    fi

    echo "VOL${icon} ${current}" > $fifo

    sleep 5
done &

# Battery
while :; do
    echo "BAT$(acpi --battery | cut -d, -f2)" > $fifo
    sleep 10
done &

tail -f $fifo | $(dirname -- $0)/parser.sh | lemonbar \
	-p \
	#-g "x60+0+0" \
	-B "${color_bg}" \
	-F "${color_fg}" \
	-f "JetBrainsMono Nerd Font Mono:size=8"
