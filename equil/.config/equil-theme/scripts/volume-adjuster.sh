#!/usr/bin/env bash

send_notification() {
    volume="$(pamixer --get-volume)"
    muted="$(pamixer --get-mute)"
    OPTION=$1
	~/.config/mako/scripts/volume.sh "$volume" "$muted" "$OPTION"
}

case $1 in
    --increase|-i)
        pamixer -i 5 && send_notification
    ;;
    --decrease|-d)
        pamixer -d 5 && send_notification
    ;;
    --mute | -m )
        pamixer -t && send_notification --toggle
    ;;
    *)
        send_notification 502
    ;;
esac