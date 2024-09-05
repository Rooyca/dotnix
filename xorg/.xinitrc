dunst &
nitrogen --restore &
#arbtt-capture &
#nicotine &

#slstatus &
#yabar -c /home/rooyca/Documents/dotfiles/.config/yabar.config &
#picom &
#nohup a2ln &
#nohup python ~/.scripts/now_playing_spotify.py &
#xmobar &
#batsignal &

# KEYBINDS
#xbindkeys
pgrep -x sxhkd > /dev/null || sxhkd &

#conky | dwm-setstatus &
#statusbar.sh &
mblocks &
#exec /usr/local/bin/dwm

#mpdnotify &
#mpdas &
cantata &

#exec spectrwm
#exec awesome
exec dwm

#while :; do
#    dwm
#done
