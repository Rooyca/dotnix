#!/bin/sh

# usbmon() {
# 	usb1=$(lsblk -la | awk '/sdc1/ { print $1 }')
# 	usb1mounted=$(lsblk -la | awk '/sdc1/ { print $7 }')

# 	if [ "$usb1" ]; then
# 		if [ -z "$usb1mounted" ]; then
# 			echo " |"
# 		else
# 			echo " $usb1 |"
# 		fi
# 	fi
# }

# fsmon() {
# 	ROOTPART=$(df -h | awk '/\/$/ { print $3}') 
# 	HOMEPART=$(df -h | awk '/\/home/ { print $3}') 
# 	SWAPPART=$(cat /proc/swaps | awk '/\// { print $4 }')

# 	echo "   $ROOTPART    $HOMEPART    $SWAPPART"
# }

ram() {
	mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')
	#echo "  $mem"
    echo "RAM: $mem"
}

cpu() {
    cpu_usage=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')
    #echo "  $cpu_usage"%
    echo "CPU: $cpu_usage"%
}

# network() {
# 	conntype=$(ip route | awk '/default/ { print substr($5,1,1) }')

# 	if [ -z "$conntype" ]; then
# 		echo "󰀂 down"
# 	elif [ "$conntype" = "e" ]; then
# 		echo "󰌗 up"
# 	elif [ "$conntype" = "w" ]; then
# 		echo " up"
# 	fi
# }

# volume_pa() {
# 	muted=$(pactl list sinks | awk '/Mute:/ { print $2 }')
# 	vol=$(pactl list sinks | grep Volume: | awk 'FNR == 1 { print $5 }' | cut -f1 -d '%')

# 	if [ "$muted" = "yes" ]; then
# 		echo "󰝟 muted"
# 	else
# 		if [ "$vol" -ge 65 ]; then
# 			echo " $vol%"
# 		elif [ "$vol" -ge 40 ]; then
# 			echo " $vol%"
# 		elif [ "$vol" -ge 0 ]; then
# 			echo " $vol%"	
# 		fi
# 	fi

# }

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
		#echo "󰝟 muted"
        echo "VOL: OFF"
	else
		#if [ "$vol" -ge 65 ]; then
		#	echo "  $vol%"
		#elif [ "$vol" -ge 40 ]; then
		#	echo " $vol%"
		#elif [ "$vol" -ge 0 ]; then
		#	echo " $vol%"	
		#fi
        echo "VOL: $vol%"
	fi
}

clock() {
	dte=$(date +"%a %d %b %Y")
	time=$(date +"%I:%M %p")

	#echo " $dte  $time"
    echo "$dte - $time"
}

battery() {
    battery_info=$(acpi -b)
    battery_percentage=$(echo "$battery_info" | grep -P -o '[0-9]+(?=%)')
    battery_status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

    # Define emoji based on battery percentage
    # Remplace BAT: with $emoji
    # case $battery_percentage in
    #     9[0-9]|100) emoji="󰂂" ;;
    #     8[0-9]) emoji="󰂁" ;;
    #     7[0-9]) emoji="󰂀" ;;
    #     6[0-9]) emoji="󰁿" ;;
    #     5[0-9]) emoji="󰁾" ;;
    #     4[0-9]) emoji="󰁽" ;;
    #     3[0-9]) emoji="󰁼" ;;
    #     2[0-9]) emoji="󰁻" ;;
    #     *) emoji="󰂃" ;;
    # esac

    # Display battery status
    [ "$battery_status" = "Discharging" ] && echo "BAT: $battery_percentage%" || echo "CHA: $battery_percentage%" #echo " $battery_percentage%"

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

detect_active_interface() {
    active_interface=$(ip route | awk '/default/ { print $5 }')
    echo "$active_interface"
}

upspeed() {
    local interface="$1"
    T1=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    sleep 1
    T2=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    TBPS=$(( T2 - T1 ))
    TKBPS=$(( TBPS / 1024 ))
    printf " ${TKBPS}Kb"
}

# Function to measure download speed
downspeed() {
    local interface="$1"
    R1=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    sleep 1
    R2=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    RBPS=$(( R2 - R1 ))
    RKBPS=$(( RBPS / 1024 ))
    printf " ${RKBPS}Kb"
}

main() {
	while true; do
		#active_interface=$(detect_active_interface)
        #$(upspeed "$active_interface") $(downspeed "$active_interface")
		echo "%{l}$(clock) %{r} $(battery) | $(ram) | $(cpu) ($(get_cpu_temp)) | $(volume_alsa) "
	done
}

main