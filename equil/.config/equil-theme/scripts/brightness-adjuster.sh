#!/usr/bin/env bash

send_notification() {
	~/.config/mako/scripts/brightness.sh "$1"
}

case $1 in
    --increase|-i)
        brightnessctl set 10%+
        percent=$(($(brightnessctl get) * 100 / 255))
        send_notification $percent
    ;;
    --decrease|-d)
        brightnessctl set 10%-
        percent=$(($(brightnessctl get) * 100 / 255))
        send_notification $percent
    ;;
    *)
        send_notification 404
    ;;
esac