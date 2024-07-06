#!/bin/bash

# Original script by @speltriao on GitHub
# https://github.com/speltriao/Pacman-Update-for-GNOME-Shell

# GUARDS
# If the operating system is not Arch Linux, exit the script successfully
[[ ! -f /etc/arch-release ]] && exit 0

# Restarts every reboot. To persist across reboot, change to /var/tmp/
CACHE_FILE=/tmp/AVAILABLE_UPDATES
# If cache doesn't exist, create and set it's value to 0
[[ ! -f $CACHE_FILE ]] && touch $CACHE_FILE && echo 0 > $CACHE_FILE
# Load updates from cache file
UPDATES=$(cat $CACHE_FILE)

print(){
    TOTAL=$1
    TEXT=""
    ALT="none"
    CLASS="none"
    TOOLTIP="Clicking this module will open\npacseek to either update or install\npackages, depending if upgrades\nare available!\n\nCTRL-U in pacseek to upgrade"
    [[ $# == 3 ]] && TOOLTIP="Available updates:\nAUR = $2 \nPAC = $3\n\n$TOOLTIP"
    
    # Thresholds
    [[ $TOTAL -gt 0 ]]  && CLASS="green"    && ALT="updates" && TEXT="$TOTAL"
    [[ $TOTAL -gt 30 ]] && CLASS="yellow"
    [[ $TOTAL -gt 70 ]] && CLASS="red"      && ALT="warning"
    
    # Remember \n at the end to flush the buffer.
    printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s" }\n' \
        "$TEXT" \
        "$ALT" \
        "$TOOLTIP" \
        "$CLASS"
}


case $1 in
    --click|-c)
        if [[ $UPDATES -gt 0 ]];then
            kitty --title pacseek pacseek -u
        else
            kitty --title pacseek pacseek
        fi
        exit 0
    ;;
    --initialize|-i)
        print "$UPDATES" "updating" "updating"
    ;;
    --get|-g|*)
        print "$UPDATES" "updating" "updating"

        # Get updates
        AUR=$(yay -Qua | wc -l)
        PAC=$(checkupdates | wc -l)
        UPDATES=$((AUR+PAC))
        echo $UPDATES > $CACHE_FILE

        print "$UPDATES" "$AUR" "$PAC"
    ;;
esac