#!/usr/bin/env bash
# ============== VARIABLES ==============#
muted=$(pamixer --get-mute)
volume=$(pamixer --get-volume)

get_icon() {
	if [[ "$muted" == "true" ]]; then
		echo ""
	elif [[ $volume -lt "33" ]]; then
		echo ""
	elif [[ $volume -lt "66" ]]; then
		echo ""
	elif [[ $volume -le "100" ]]; then
		echo ""
	else
		echo ""
	fi
}

notify_user() {
	$HOME/.config/mako/scripts/volume.sh $1 $2 $3
}

TOGGLE_FILE="$HOME/.config/waybar/modules/scripts/.speaker-toggle"
toggle_alt(){
	if [[ ! -e $TOGGLE_FILE ]];then
		touch $TOGGLE_FILE
	else
		rm $TOGGLE_FILE
	fi
	pamixer -t
	pamixer -t
}

get_text(){
	if [[ ! -e $TOGGLE_FILE ]];then
		# printf "%s %s%%" "$(get_icon)" "$volume"
		echo "$(get_icon)"
	else
		printf "%s %s" "$(get_icon)" "$volume%"
	fi
}

get_class(){
	if [[ $muted == "true" ]];then
        echo "off"
	elif [[ $volume -lt "33" ]];then
		echo "low"
	elif [[ $volume -lt "66" ]];then
		echo "mid"
	elif [[ $volume -lt "100" ]];then
		echo "high"
	fi
}


case $1 in
	--get)
		update(){
			status=($(pamixer --get-mute --get-volume))
			muted=${status[0]}
			volume=${status[1]}
			printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s", "percentage": "%s" }\n' "$(get_text)" "$(get_text)" "Volume at: $volume%" "$(get_class)" "$volume"
		}

		update

		# TODO kill subscription on parent kill | how? help!
		# This also means it's currently discourage to use mouse-up and mouse-down to alter volume
		pactl subscribe | grep --line-buffered "Event 'change' on sink" | while read line; do
			update
		done
	;;
	--inc)
		pamixer -i 5 && notify_user --inc $(pamixer --get-volume) $muted
	;;
	--dec)
		pamixer -d 5 && notify_user --dec $(pamixer --get-volume) $muted
	;;
	--toggle)
		if [[ "$muted" == "true" ]];then
			pamixer -u && notify_user --toggle $volume "false"
		else
			pamixer -m && notify_user --toggle $volume "true"
		fi
	;;
	--toggle-off)
		if [[ "$(pamixer --get-mute)" == "true" ]];then
			pamixer -u && notify_user --toggle $volume "false"
		fi
	;;
	--toggle-on)
		if [[ "$(pamixer --get-mute)" == "false" ]];then
			pamixer -m && notify_user --toggle $volume "true"
		fi
	;;
	--toggle-alt)
		toggle_alt
	;;
esac

exit 0