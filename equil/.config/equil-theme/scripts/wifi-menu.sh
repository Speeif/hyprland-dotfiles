#!/usr/bin/env bash
inpt=$1
# Vaerify input
VALID_ARGS=$(getopt -o lch --long list,connect,help -- "$@")
[[ $? -ne 0 ]] && inpt="--help" && echo -e "\e[1;32m[Argument not supported]\e[0m"

case inpt in
    -l | -list)
        SSID=$(nmcli device wifi list --rescan no | sed -En "s/^.*[\w\d:]{17}\s+([[:alnum:]])/\1/p" | grep -E "[^--]" | rofi -dmenu)
    ;;
    -c | --connect)

    ;;
    -h | --help)

    ;;
esac