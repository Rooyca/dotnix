#!/bin/bash

mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')
echo "RAM: $mem "