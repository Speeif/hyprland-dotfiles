#!/usr/bin/env bash

MIC="$HOME/.config/mako/icons/microphone.png"
MUTE="$HOME/.config/mako/icons/microphone-mute.png"

VOLUME="$2"
MUTED="$3"

notif(){
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$1" "$2"
}

get_icon(){
    if [[ $MUTED == "true" ]];then
        echo $MUTE
    else
        echo $MIC
    fi
}

case $1 in
    --inc | --dec)
        notif $(get_icon) "Microphone : $VOLUME %"
    ;;
    --toggle)
        if [[ $MUTED == "true" ]]; then
            notif $(get_icon) "Mic turned OFF"
        else
            notif $(get_icon) "Mic turned ON"
        fi
    ;;
esac