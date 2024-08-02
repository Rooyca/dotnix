#!/bin/sh

# Get the terminal width once
cols=$(tput cols)

while :; do
    # Read each line of output from conky directly
    conky -c ~/.conkyrc | {
        while IFS= read -r line; do
            # Use printf to pad the left side, moving the content to the right
            printf "%*s\n" $((cols -60)) "$line"
        done
    }
done