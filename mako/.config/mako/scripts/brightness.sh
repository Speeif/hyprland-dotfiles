#!/usr/bin/env bash

LOW="$HOME/.config/mako/icons/brightness-20.png"
LOWMID="$HOME/.config/mako/icons/brightness-40.png"
MID="$HOME/.config/mako/icons/brightness-60.png"
MIDHIGH="$HOME/.config/mako/icons/brightness-80.png"
HIGH="$HOME/.config/mako/icons/brightness-100.png"

BRIGHTNESS="$1"
MUTED="$2"

# notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$MID" "alpha"

send_notification(){
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$1" "$2"
}

get_icon(){
    if [[ "$BRIGHTNESS" -le "20" ]];then
        echo "$LOW"
    elif [[ "$BRIGHTNESS" -le "40" ]];then
        echo "$LOWMID"
    elif [[ "$BRIGHTNESS" -le "60" ]];then
        echo "$MID"
    elif [[ "$BRIGHTNESS" -le "80" ]];then
        echo "$MIDHIGH"
    elif [[ "$BRIGHTNESS" -le "100" ]];then
        echo "$HIGH"
    fi
}

send_notification "$(get_icon)" "Brightness : $BRIGHTNESS %"