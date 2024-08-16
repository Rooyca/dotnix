#!/bin/bash

bright=$(brightnessctl | grep -oP '\(\d+%\)' | tr -d '()')
echo "BRI: $bright "