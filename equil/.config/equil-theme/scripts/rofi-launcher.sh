#!/usr/bin/env bash

inpt=$1
# Vaerify input
VALID_ARGS=$(getopt -o afwh --long application,filebrowser,wallpaper,help -- "$@")
[[ $? -ne 0 ]] && inpt="--help" && echo -e "\e[1;32m[Argument not supported]\e[0m"

w
eval set -- "$VALID_ARGS"
case "$inpt" in
    -a | --application) rofi -show drun ;;
    -f | --filebrowser) rofi -show filebrowser ;;
    -w | --wallpaper)
        
        PICS=($(find $HOME/wallpapers/* -type f \( -iname \*.jpg -o -iname \*.png \) |sort ))

        manu(){
            for i in "${!PICS[@]}"; do
                printf "$(basename "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${PICS[$i]}\n"
            done
        }

        theme=~/.config/rofi/configs/wallpaper-select.rasi
        choice=$(manu | rofi -show -dmenu -theme $theme)

        for file in "${PICS[@]}"; do
            if [[ "$(basename "$file" | cut -d. -f1)" = "$choice" ]];then
                choice="$file"
            fi
        done
        echo "$choice"
        ~/.config/equil-theme/scripts/theme-setter.sh $choice --animated
    ;;
    ? | -h | --help)
echo "This script supports a list of different arguments
for launching Rofi in different configurations and
styles
    -a , --application
        Launches rofi as an application launcher
    -f , --filebrowser
        Launches rofi as a file launcher
    -w , --wallpaper
        Launches rofi to select a wallpaper
    -h , --help
        Shows this message
";;
esac