#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash

count=$(remind -s ~/.reminders/primary.rem | grep "$(date '+%Y/%m/%d')" | wc -l)

if [ "$count" -ne 0 ]; then
    echo "[ 󱅫 $count ]" > ~/.reminders/today
else
    echo "" > ~/.reminders/today
fi