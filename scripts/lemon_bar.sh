#!/usr/bin/bash

Clock(){
        TIME=$(date "+%H:%M:%S")
        echo -e -n " \uf017 ${TIME}" 
}

Cal() {
    DATE=$(date "+%a, %m %B %Y")
    echo -e -n "\uf073 ${DATE}"
}

Battery() {
        BATTACPI=$(acpi --battery)
        BATPERC=$(echo $BATTACPI | cut -d, -f2 | tr -d '[:space:]')

        if [[ $BATTACPI == *"100%"* ]]
        then
                echo -e -n "\uf00c $BATPERC"
        elif [[ $BATTACPI == *"Discharging"* ]]
        then
                BATPERC=${BATPERC::-1}
                if [ $BATPERC -le "10" ]
                then
                        echo -e -n "\uf244"
                elif [ $BATPERC -le "25" ]
                then
                        echo -e -n "\uf243"
                elif [ $BATPERC -le "50" ]
                then
                        echo -e -n "\uf242"
                elif [ $BATPERC -le "75" ]
                then
                        echo -e -n "\uf241"
                elif [ $BATPERC -le "100" ]
                then
                        echo -e -n "\uf240"
                fi
                echo -e " $BATPERC%"
        elif [[ $BATTACPI == *"Charging"* && $BATTACPI != *"100%"* ]]
        then
                echo -e "\uf0e7 $BATPERC"
        elif [[ $BATTACPI == *"Unknown"* ]]
        then
                echo -e "$BATPERC"
        fi
}

while true; do
        echo -e "%{c}$(Clock) $(Cal) %{r}$(Battery) "
        sleep 1
done