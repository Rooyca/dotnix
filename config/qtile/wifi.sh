#!/bin/bash

state=$(nmcli general | awk '{print $1}' | tail -n 1)
connectivity=$(nmcli general | awk '{print $4}' | tail -n 1)

if [[ "$state" = "disconnected" || "$connectivity" = "limited" ]]; then
	echo "󱛅"
else
	echo "󰖩"
fi
