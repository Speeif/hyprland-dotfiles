#!/usr/bin/env bash
BRIGHTNESS_ADJUSTER="$HOME/.config/equil-theme/scripts/brightness-adjuster"

TOGGLE_FILE="/var/tmp/.screen-toggle"
toggle_alt(){
	[[ ! -e $TOGGLE_FILE ]]\
		&& touch $TOGGLE_FILE\
		|| rm $TOGGLE_FILE
}

get_text(){
	brightness=$1
	# Get icon
	icon="err"
	[[ "$brightness" -ge "0" ]] && icon="󰃞"
	[[ "$brightness" -ge "33" ]] && icon="󰃟"
	[[ "$brightness" -ge "66" ]] && icon="󰃠"
	# Alt text
	text="$icon"
	[[ ! -e $TOGGLE_FILE ]] && text="$text $brightness"	
	echo $text
}

get_class(){
	brightness=$1
	class="off"
	[[ "$brightness" -gt "0" ]] && class="low"
	[[ "$brightness" -ge "33" ]]&& class="mid" 
	[[ "$brightness" -ge "66" ]]&& class="high"
	echo $class
}

case $1 in
	test)
		brightness=$(brightnessctl get)
		percent=$(($brightness * 100 / 255))
		echo $(get_class $percent)
	;;
	--get)
		update(){
			brightness=$(brightnessctl get)
			percent=$(($brightness * 100 / 255))
			text=$(get_text $percent)
			class=$(get_class $percent)

			tooltip="Current brightness: $percent%\n\n
			[left-click]: <TODO>\n
			[right-click]: Toggle alt format\n
			[scroll-down]: Decrease brightness\n
			[scroll-up]: Increase brightness"

			tooltip=$(echo $tooltip | sed 's/\\n\s*/\\n/g')

			printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s", "percentage": "%s" }\n' "$text" "$text" "$tooltip" "$class" "$percent"
		}
		update

		# Subscribe to screen event
		# TODO: Currently specific to this installation
		# dbus-monitor interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile | while read line; do 
		# 	update
		# done
	;;
	--inc)
		brightnessctl set 10%+ && notify_user --inc $(($(brightnessctl get) * 100 / 255))
	;;
	--dec)
		brightnessctl set 10%- && notify_user --dec $(($(brightnessctl get) * 100 / 255))
	;;
	--toggle-alt)
		# Toggle text and update DBUS
		toggle_alt && brightnessctl set 0+
	;;
esac