#!/bin/bash

output=$(~/.local/bin/td | tr -d '\n')

left=$(echo "$output" | awk '{print $(NF-1)}')
completed=$(echo "$output" | awk '{print $(NF-3)}')

echo " 󰃁 $completed | 󰧌 $left "