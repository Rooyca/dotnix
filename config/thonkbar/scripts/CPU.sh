#!/bin/bash

cpu_usage=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')
temp0=$(acpi -t | grep 'Thermal 0' | awk '{print $4}' | awk -F'.' '{print $1}')
stat="$temp0ºC"
echo "CPU: $cpu_usage% ($stat) "
if [ "$cpu_usage" -gt 90 ]; then
    echo "#f71e30"
fi