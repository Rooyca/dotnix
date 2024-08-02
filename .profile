export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
#export QT_QPA_PLATFORM="wayland-egl"
#export ELM_DISPLAY="wl"
#export COUNTDOWN_TIME="3"
#export NIX_PATH=$HOME/.nix-defexpr/channels

[ ! -s ~/.config/mpd/pid ] && mpd

#if ! pgrep -x "mpdscribble" > /dev/null; then
#    mpdscribble
#fi

#if !pgrep -x "mblocks" > /dev/null; then
#	mblocks &
#fi