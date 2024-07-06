#!/usr/bin/env bash
BACKGROUND_CACHE="$HOME/.cache/wallpaper"
WALLPAPERS_DIR="$HOME/wallpapers"
ALL_WALLPAPERS=($(basename -a $WALLPAPERS_DIR/*))

# Find next wallpaper
GET_INDEX(){
    WP=$(cat $BACKGROUND_CACHE)
    for index in ${!ALL_WALLPAPERS[*]};do
        if [ "${ALL_WALLPAPERS[$index]}" == "$(basename $WP)" ];then
            case $1 in
                -d|--decrease)
                    new_index=$(( $index - 1 ))
                    if [ $new_index -le 0 ]; then
                        echo $(( ${#ALL_WALLPAPERS[*]} - 1 ))
                    else 
                        echo $new_index
                    fi
                ;;
                -i|--increase)
                    echo $(( ($index + 1) % ${#ALL_WALLPAPERS[*]} ))
                ;;
                --init)
                    echo "$index"
                ;;
            esac
        fi 
    done
}

new_index=$(GET_INDEX "$1")
echo "$WALLPAPERS_DIR/${ALL_WALLPAPERS[$new_index]}"


echo ". ~/.dotfiles/equil/scripts/theme-setter.sh "$WALLPAPERS_DIR/${ALL_WALLPAPERS[$new_index]}" --animated"
. ~/.dotfiles/equil/scripts/theme-setter.sh "$WALLPAPERS_DIR/${ALL_WALLPAPERS[$new_index]}" --animated
# Set theme


# BACKGROUND_CACHE="$HOME/.cache/current_wallpaper"
# ALL_WALLPAPERS=($(basename -a $WALLPAPERS_DIR/*))

# # Create cache file
# if [ ! -f "$BACKGROUND_CACHE" ];then
#     touch "$BACKGROUND_CACHE"
#     echo "$WALLPAPERS_DIR/default.jpg" > "$BACKGROUND_CACHE"
# fi

# get_wallpaper(){
#     current_wallpaper=$(cat "$BACKGROUND_CACHE")
#     case $1 in
#         --inc|--dec)
#         for index in ${!ALL_WALLPAPERS[*]};do
#             if [ "${ALL_WALLPAPERS[$index]}" == "$(basename "$current_wallpaper")" ];then
#                 new_index=0;

#                 # Get new index
#                 case $1 in
#                     --inc)
#                         new_index=$(( ($index + 1) % ${#ALL_WALLPAPERS[*]} ))
#                     ;;
#                     --dec)
#                         new_index=$(($index - 1))
#                         if [ $new_index -lt 0 ];then 
#                             new_index=$(( ${#ALL_WALLPAPERS[*]} - 1))
#                         fi
#                     ;;
#                 esac
#                 # Print new wallpaper
#                 echo "$WALLPAPERS_DIR/${ALL_WALLPAPERS[$new_index]}"
#                 exit 0
#             fi
#         done
#         ;;
#         *) echo "$WALLPAPERS_DIR/$current_wallpaper";;
#     esac
# }

# set_background(){
#     case $1 in
#         --animated)
#             swww img $2\
#                 --transition-bezier .45,1.19,1,.4 \
#                 --transition-fps=60 \
#                 --transition-type="wipe" \
#                 --transition-duration=0.75 \
#                 --transition-pos "1885, 25"
#         ;;
#         --default)
#             swww img $2
#         ;;
#     esac
# }

# create_css_files(){
#     # Produces css files in ~/.cache/wal/
#     # Using gtk.css file from templates
#     wal -q -i "$1" -n
# }

# update_hyprland(){
#     # Restart waybar
#     hyprctl dispatch exec /home/speeif/.config/hypr/scripts/launch-waybar.sh > /dev/null
#     # Set hyprland border
#     accent="$(cat ~/.cache/wal/gtk.css | sed -En "s/@define-color accent #([[:alnum:]]+);/\1/p")"
#     hyprctl keyword general:col.active_border "rgb($accent) 45deg" lock 1> /dev/null
# }

# wp=""
# case $1 in
#     --init)
#         wp="$(get_wallpaper)"
#         set_background --default "$wp"
#         update_hyprland
#         exit 0
#     ;;
#     --next) wp="$(get_wallpaper --inc)";;
#     --previous) wp="$(get_wallpaper --dec)";;
#     *) exit 0;;
# esac

# # Update cache file
# echo "$wp" > "$BACKGROUND_CACHE"
# echo "$wp"
# hyprctl dispatch exec "$HOME/.dotfiles/equil/scripts/theme-setter.sh \"$wp\" --animated"