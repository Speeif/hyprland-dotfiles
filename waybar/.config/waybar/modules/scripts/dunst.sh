#!usr/bin/env bash
echo "YES!"
set -exuo pipefail

readonly ENABLED=''
readonly DISABLED=''
dbus-monitor path='/org/freedesktop/Notifications',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile |
  while read -r _; do
    case "$(dunstctl is-paused)" in
        true)
            COUNT=$(dunstclt count waiting)
            if [ "$COUNT" != '0'];then
                printf '{"text": "%s" , "class": "%s"}' "$DISABLED $COUNT" "disabled"
            else
                printf '{"text": "%s" , "class": "%s"}' "$DISABLED" "disabled"
            fi
        ;;
        false)
            printf '{"text": "%s" , "class": "%s"}' "$ENABLED" "enabled"
        ;;
    esac


    # if [ "$PAUSED" == 'false' ]; then
    #   CLASS="enabled"
    #   TEXT="$ENABLED"
    # else
    #   CLASS="disabled"
    #   TEXT="$DISABLED"
    #   COUNT="$(dunstctl count waiting)"
    #   if [ "$COUNT" != '0' ]; then
    #     TEXT="$DISABLED ($COUNT)"
    #   fi
    # fi
    # printf '{"text": "%s", "class": "%s"}\n' "$TEXT" "$CLASS"
  done