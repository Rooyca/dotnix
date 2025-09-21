#!/bin/bash

vol=$(amixer get Master | grep -o -m 1 "[0-9]*%")
#echo "VOL: $vol "
echo "$vol "