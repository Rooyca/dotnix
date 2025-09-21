#!/bin/bash

count=$(atq | grep "$(date '+%a %b %d')" | wc -l)

if [ "$count" -ne 0 ]; then
    echo "[ 󱅫 $count ]"
else
    echo ""
fi