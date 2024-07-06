#!/usr/bin/env bash

LOW="$HOME/.config/mako/icons/volume-low.png"
MID="$HOME/.config/mako/icons/volume-mid.png"
HIGH="$HOME/.config/mako/icons/volume-high.png"
MUTE="$HOME/.config/mako/icons/volume-mute.png"

VOLUME="$1"
MUTED="$2"
OPTION="$3"

notif(){
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$1" "$2"
}

get_icon(){
    icon=""
    [[ $VOLUME -ge "0" ]] && icon="$LOW"
    [[ $VOLUME -ge "33" ]] && icon="$MID"
    [[ $VOLUME -ge "66" ]] && icon="$HIGH"
    [[ "$MUTED" == "true" ]] && icon="$MUTE"
    echo "$icon"
}

case $OPTION in
    --inc | --dec | *)
        notif $(get_icon) "Volume : $VOLUME %"
    ;;
    --toggle)
        if [[ $MUTED == "true" ]]; then
            notif $(get_icon) "Volume Switched OFF"
        else
            notif $(get_icon) "Volume Switched ON"
        fi
    ;;
esac