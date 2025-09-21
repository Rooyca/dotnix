#!/bin/bash

# Get current volume
VOLUME=$(amixer get Master | grep -o "[0-9]*%" | head -n1)

# Show notification
notify-send -t 1000 "Volume" "Volume: ${VOLUME} 🔊"
