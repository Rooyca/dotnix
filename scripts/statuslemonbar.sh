#!/bin/bash

ram() {
	mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')
    if [ $(echo "$mem" | cut -f1 -d 'G') -gt 2 ]; then
        echo "RAM: %{F#f71e30} $mem%{F-}"
    else
        echo "RAM: $mem"
    fi

}

cpu() {
    cpu_usage=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')
    if [ "$cpu_usage" -gt 90 ]; then
        echo "CPU: %{F#f71e30}$cpu_usage% %{F-}"
    else
        echo "CPU: $cpu_usage%"
    fi
}

volume_alsa() {
	mono=$(amixer -M sget Master | grep Mono: | awk '{ print $2 }')

	if [ -z "$mono" ]; then
		muted=$(amixer -M sget Master | awk 'FNR == 6 { print $7 }' | sed 's/[][]//g')
		vol=$(amixer -M sget Master | awk 'FNR == 6 { print $5 }' | sed 's/[][]//g; s/%//g')
	else
		muted=$(amixer -M sget Master | awk 'FNR == 5 { print $6 }' | sed 's/[][]//g')
		vol=$(amixer -M sget Master | awk 'FNR == 5 { print $4 }' | sed 's/[][]//g; s/%//g')
	fi

	if [ "$muted" = "off" ]; then
        echo "VOL: %{F#f71e30}OFF%{F-}"
	else
        echo "VOL: $vol%"
	fi
}

clock() {
	dte=$(date +"%a %d %b %Y")
	time=$(date +"%I:%M %p")

    echo "$dte - $time"
}

battery() {
    battery_info=$(acpi -b)
    battery_percentage=$(echo "$battery_info" | grep -P -o '[0-9]+(?=%)')
    battery_status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

    # Display battery status
    [ "$battery_status" = "Discharging" ] && echo "BAT: $battery_percentage%" || echo "CHA: %{F#34eb5e}$battery_percentage%%{F-}" #echo " $battery_percentage%"

    # Notification logic
    if [ "$battery_status" = "Discharging" ]; then
        if [ "$battery_percentage" -lt 10 ]; then
            [ ! -f /tmp/battery_warning ] && notify-send "Battery Low" "Battery below 10%" -u critical && touch /tmp/battery_warning
        elif [ "$battery_percentage" -lt 20 ]; then
            [ ! -f /tmp/battery_notification ] && notify-send "Battery Low" "Battery below 20%" -u normal && touch /tmp/battery_notification
        else
            rm -f /tmp/battery_notification /tmp/battery_warning
        fi
    else
        rm -f /tmp/battery_notification /tmp.battery_warning
        if [ "$battery_percentage" -ge 98 ]; then
            [ ! -f /tmp/battery_full ] && notify-send "Battery Full" "Battery at 98%" -u normal && touch /tmp/battery_full
        else
            rm -f /tmp/battery_full
        fi
    fi
}

get_cpu_temp() {
    temp0=$(acpi -t | grep 'Thermal 0' | awk '{print $4}' | awk -F'.' '{print $1}')
    stat="$temp0ºC"
    
    echo $stat
}

get_workspace() {
    #wsname=$(bspc query -D -d focused --names)
    wsnum=$(bspc query -N -d $somedesktop -n .window.\!hidden | wc -l)
    if [ $wsnum -ge 2 ]; then
        echo "[$wsnum]"
    fi
}

main() {
	while true; do
		echo "  %{l} $(get_workspace)%{c}$(clock)%{r}| $(battery) | $(ram) | $(cpu) ($(get_cpu_temp)) | $(volume_alsa) "
        sleep 1
	done
}

main