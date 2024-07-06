#!/usr/bin/env bash
# ============== VARIABLES ==============#
muted=$(pamixer --default-source --get-mute)
volume=$(pamixer --default-source --get-volume)

get_icon() {
	if [[ "$muted" == "true" ]]; then
		echo ""
	else
		echo ""
	fi
}

notify_user() {
	"$HOME/.config/mako/scripts/microphone.sh" "$1" "$2" "$3"
}

TOGGLE_FILE="$HOME/.config/waybar/modules/scripts/.microphone-toggle"
toggle_alt(){
	if [[ ! -e $TOGGLE_FILE ]];then
		touch "$TOGGLE_FILE"
	else
		rm "$TOGGLE_FILE"
	fi
	pamixer --default-source -t
	pamixer --default-source -t
}

get_text(){
	if [[ ! -e $TOGGLE_FILE ]];then
		echo "$(get_icon)"
	else
		echo "$(get_icon) $volume%"
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
			muted2=$(pamixer --default-source --get-mute)
			[[ ! -z $muted2 ]] && muted=$muted2
			volume2=$(pamixer --default-source --get-volume)
			[[ ! -z $volume2 ]] && volume=$volume2
			printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s", "percentage": "%s" }\n' "$(get_text)" "$muted $volume" "Microphone at: $volume%" "$(get_class)" "$volume"
		}

		update

		# TODO kill subscription on parent kill | how? help!
		# This also means it's currently discourage to use mouse-up and mouse-down to alter volume
		pactl subscribe | grep --line-buffered "source" | while read line; do
			update
		done
	;;
	--inc)
		pamixer --default-source -i 5 && notify_user --inc "$(pamixer --default-source --get-volume)" "$muted"
	;;
	--dec)
		pamixer --default-source -d 5 && notify_user --dec "$(pamixer --default-source --get-volume)" "$muted"
	;;
	--toggle)
		if [[ "$muted" == "true" ]];then
			pamixer --default-source -u && notify_user --toggle "$volume" "true"
		else
			pamixer --default-source -m && notify_user --toggle "$volume" "false"
		fi
	;;
	--toggle-on)
		if [[ "$(pamixer --default-source --get-mute)" == "true" ]];then
			pamixer --default-source -u && notify_user --toggle "$volume" "false"
		fi
	;;
	--toggle-off)
		if [[ "$(pamixer --default-source --get-mute)" == "false" ]];then
			pamixer --default-source -m && notify_user --toggle "$volume" "true"
		fi
	;;
	--toggle-alt)
		toggle_alt
	;;
	--test)
		notify_user "$2"
	;;
esac

exit 0