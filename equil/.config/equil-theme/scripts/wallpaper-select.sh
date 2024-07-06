#!/usr/bin/env bash
# This uses WOFI as the image selector
ls ~/wallpapers/ | sed -En "s|(.*)|img:$HOME/wallpapers/\1:text:\1|p" | wofi --dmenu