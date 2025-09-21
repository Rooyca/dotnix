#!/bin/bash

# Get the default sink (output device)
sink=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Get the volume of the default sink in percentage (left channel)
volume=$(pactl list sinks | grep -A 15 "Name: $sink" | grep "Volume: front-left" | awk '{print $5}' | sed 's/%//')

echo "$volume%"

