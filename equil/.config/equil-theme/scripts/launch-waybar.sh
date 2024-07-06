#!/usr/bin/env bash

killall waybar
killall pactl
pkill waybar

# Start waybar
waybar &