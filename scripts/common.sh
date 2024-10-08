#!/bin/bash

theme="dracula"

case $theme in
    "dracula")
        color_bg="#282a36"
        color_fg="#f8f8f2"
        color_hl1="#6272a4"
        color_hl2="#bd93f9"
        ;;
    *) # Default to Nord
        color_bg="#2e3440"
        color_fg="#eceff4"
        color_hl1="#5e81ac"
        color_hl2="#81a1c1"
        ;;
esac

bspc_desktops() {
    desktops=$(bspc query -D --names)
    buf=""
    for d in ${desktops[@]}; do
        if [[ "$(bspc query -D -d focused --names)" == "${d}" ]]; then
            buf="${buf}%{B${color_hl2}}  ${d}  %{B-}"
        else
            buf="${buf}  ${d}  "
        fi
    done

    echo "${buf}"
}
