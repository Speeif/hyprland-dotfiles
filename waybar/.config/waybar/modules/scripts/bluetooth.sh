#!/usr/bin/env bash

case $1 in
    --toggle)
        STATUS=$(bluetoothctl show | sed -n "s/^.*Powered: \(yes\|no\)/\1/p")

        if [[ $STATUS == "yes" ]]; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
    ;;
    --manage)
        blueman-manager
    ;;
esac

