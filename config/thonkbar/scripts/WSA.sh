#!/bin/bash

#wsname=$(bspc query -D -d focused --names)
wsnum=$(bspc query -N -d $somedesktop -n .window.\!hidden | wc -l)
if [ $wsnum -gt 1 ]; then
	echo "< $wsnum >"
fi