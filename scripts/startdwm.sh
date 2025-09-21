#!/bin/sh

dunst &
nitrogen --restore &
#arbtt-capture &
#nicotine &
# KEYBINDS
#xbindkeys
pgrep -x sxhkd > /dev/null || sxhkd &

#/home/ryc/.local/bin/statusbar.sh &
/home/ryc/.cargo/bin/mblocks &

while true; do
	dwm 2> ~/.dwn.log
done
