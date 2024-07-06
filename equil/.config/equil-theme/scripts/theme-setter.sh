#!/usr/bin/env bash
#  _________  ___  ___  ______   _____ ______   _______           ________  ______    _________  _________  ________  ________
# |\___   ___\\  \|\  \|\   ___\|\   _ \  _   \|\    ___\        |\   ____\|\   ___\|\___   ___\\___   ___\\   ____\|\   __  \
# \|___ \  \_\ \  \\\  \ \  \__|\ \  \\\__\ \  \ \  \___|        \ \  \___|\ \  \__|\|___ \  \_\|___ \  \_\ \  \___|\ \  \|\  \
#      \ \  \ \ \   __  \ \   __\\ \  \\|__| \  \ \   ___\        \ \_____  \ \   __\    \ \  \     \ \  \ \ \   __\ \ \   _  _\
#       \ \  \ \ \  \ \  \ \  \_|_\ \  \    \ \  \ \  \__|__       \|____|\  \ \  \_|_    \ \  \     \ \  \ \ \  \_|__\ \  \\  \|
#        \ \__\ \ \__\ \__\ \______\ \__\    \ \__\ \_______\       |\________\ \______\   \ \__\     \ \__\ \ \_______\ \__\\ _\
#         \|__|  \|__|\|__|\|______|\|__|     \|__|\|_______|       \|________|\|______|    \|__|      \|__|  \|_______|\|__|\|__|
# ~ Speeif

# ############### ({[ ARGUMENTS ]}) ############### #
#  1. Link to image file
#  2. Wallpaper animation type
#       "--none":       no animation
#       "--animated":   Beziere animation [DEFAULT]

# This script needs at least 1 argument, which is supposed to be
# an image file, either a .jpg or .png.

# GUARDS
[[ ! $# -ge 1 && ! $# -le 2 ]] && echo "incorrect usage of theme setter! Theme setter uses 1-2 arguments" && exit 1
[[ ! -f $1 ]]&& echo "File does not exist" && exit 1
[[ ! $1 == *.jpg && ! $1 == *.png ]] && echo "File extension not supported!" && exit 1

# =============== ({[ VARIABLES ]}) =============== #
WAL_COLOR_FILE="$HOME/.cache/wal/gtk.css"
BACKGROUND_CACHE="$HOME/.cache/wallpaper"

# =============== ({[ COLOR GEN ]}) =============== #
# generate css using pywal
wal -q -i "$1" -n
COLOR_ACCENT="$(cat $WAL_COLOR_FILE | sed -En "s/@define-color accent #([[:alnum:]]+);/\1/p")"
COLOR_BACKGROUND="$(cat $WAL_COLOR_FILE | sed -En "s/@define-color background #([[:alnum:]]+);/\1/p")"
COLOR_FOREGROUND="$(cat $WAL_COLOR_FILE | sed -En "s/@define-color foreground #([[:alnum:]]+);/\1/p")"

# =============== ({[ BACKGROUND ]}) =============== #
# Set background using swww
case $2 in
    --none)
        swww img "$1"
    ;;
    --animated|*)
        swww img "$1"\
            --transition-bezier .45,1.19,1,.4 \
            --transition-fps=60 \
            --transition-type="wipe" \
            --transition-duration=0.75 \
            --transition-pos "1885, 25"
    ;;
esac
# update wallpaper cache
echo "$1" > "$BACKGROUND_CACHE"

# =============== ({[ HYPRLAND ]}) =============== #
# Set hyprland borders
hyprctl keyword general:col.active_border "rgb($COLOR_ACCENT) 45deg" lock 1> /dev/null


# =============== ({[ WAYBAR ]}) =============== #
# RESTART WAYBAR
hyprctl dispatch exec /home/speeif/.config/hypr/scripts/launch-waybar.sh > /dev/null

# =============== ({[ PACSEEK ]}) =============== #
# Pacseek is handled by pywal, where the css file
# produced by the template file is a symbolic link
# towards the colors.json file in the pacseek
# configuration file.

# =============== ({[ SDDM ]}) =============== #
sddm_theme=/usr/share/sddm/themes/sdt

# Duplicate wallpapers for SDDM
user_wallpapers=(~/wallpapers/*)
for file in "${user_wallpapers[@]}"; do
    base=$(basename "$file")
    if [ ! -f "$sddm_theme/Backgrounds/$base" ]; then
        cp "$HOME/wallpapers/$base" "$sddm_theme/Backgrounds/$base"
        printf "\e[1;34m[CP]\e[0m: \"%s\" into \"%s\"\n" "$HOME/wallpapers/$base" "$sddm_theme/Backgrounds/$base"
    fi
done
# Run SDDM cleanup
sddm_wallpapers=($(ls "$sddm_theme/Backgrounds"))
for file in "${sddm_wallpapers[@]}"; do
    base=$(basename "$file")
    if [ ! -f "$HOME/wallpapers/$base" ]; then
        # rm "$sddm_theme/Backgrounds/$base"
        printf "\e[1;34m[RM]\e[0m: \"%s\" deleted\n" "$sddm_theme/Backgrounds/$base"
    fi
done

# Set sddm background to current background
file_name=$(basename "$1")
ln -sf "$sddm_theme/Backgrounds/$file_name" "$sddm_theme/wallpaper.jpg"

# Set colors in the theme folder
 sed -i -E "s/(AccentColor=\"#).*\"/\1$COLOR_ACCENT\"/g" $sddm_theme/theme.conf
 sed -i -E "s/(BackgroundColor=\"#).*\"/\1$COLOR_BACKGROUND\"/g" $sddm_theme/theme.conf
 sed -i -E "s/(MainColor=\"#).*\"/\1$COLOR_FOREGROUND\"/g" $sddm_theme/theme.conf

# =============== ({[ SWAYLOCK ]}) =============== #
IMAGE=$1
# sed -i -E --follow-symlinks "s/(key-hl-color=).*$/\1$COLOR_ACCENT/g" "$HOME/.swaylock/config"
# sed -i -E --follow-symlinks "s/(text-clear-color=).*$/\1$COLOR_FOREGROUND/g" "$HOME/.swaylock/config"
sed -i -E --follow-symlinks "s|(indicator-image=).*$|\1${IMAGE}|g" "$HOME/.swaylock/config"