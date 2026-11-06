#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FIELDS=SSID,SECURITY

if [ -r "$DIR/config" ]; then
	source "$DIR/config"
elif [ -r "$HOME/.config/rofi/wifi" ]; then
	source "$HOME/.config/rofi/wifi"
else
	echo "WARNING: config file not found! Using default values." >&2
fi

# extra arguments (e.g. -theme) are forwarded to rofi, see rofi/entry.sh
rofi_command="rofi -dmenu $*"

DIVIDER='---------'
MANUAL='manual'
RESCAN='rescan'
CONNECTED='connected'
CONNECT='connect'
FORGET='forget'

MANUAL_HINT='enter the SSID of the network (SSID,password)'
PASSWORD_HINT='if connection is stored, hit enter'

wifi_enabled() {
	[[ $(nmcli -fields WIFI g) == *enabled* ]]
}

saved_connections() {
	nmcli -t -f NAME connection show
}

ssid_list() {
	# drop the column header so it can not be picked as a network name
	nmcli --fields "$FIELDS" device wifi list | sed '/^--/d;1d'
}

# entries come from stdin, the prompt and the entry placeholder are per view
pick() {
	local prompt="$1"
	local placeholder="$2"
	shift 2

	$rofi_command -p "$prompt" -theme-str "entry { placeholder: \"$placeholder\"; }" "$@"
}

# drop everything after the first column of `nmcli device wifi list`
entry_ssid() {
	local ssid=${1%%  *}
	printf '%s\n' "$ssid"
}

connect_ssid() {
	local entry="$1"
	local ssid password

	ssid=$(entry_ssid "$entry")
	[ -z "$ssid" ] && return 0

	# a stored connection only needs to be brought up
	if grep -Fxq -- "$ssid" <<< "$(saved_connections)"; then
		nmcli connection up "$ssid"
		return 0
	fi

	if [[ $entry =~ WPA|WEP|SAE|802\.1X ]]; then
		password=$(echo "$PASSWORD_HINT" | pick 'password:' 'enter password' -lines 1)

		# cancelled, or the hint row was picked instead of typing a password
		if [ -z "$password" ] || [ "$password" = "$PASSWORD_HINT" ]; then
			return 0
		fi

		nmcli dev wifi con "$ssid" password "$password"
	else
		nmcli dev wifi con "$ssid"
	fi
}

manual_entry() {
	local input ssid password

	input=$(echo "$MANUAL_HINT" | pick 'Manual Entry:' 'SSID,password' -lines 1)

	# cancelled, or the hint row was picked instead of typing an SSID
	if [ -z "$input" ] || [ "$input" = "$MANUAL_HINT" ]; then
		return 0
	fi

	ssid=${input%%,*}
	password=${input#*,}
	[ "$password" = "$input" ] && password=''

	if [ -z "$password" ]; then
		nmcli dev wifi con "$ssid"
	else
		nmcli dev wifi con "$ssid" password "$password"
	fi
}

saved_actions() {
	local name="$1"
	local action

	action=$(printf '%s\n%s\n' "$CONNECT" "$FORGET" |
		pick "Action: $name" 'connect or forget' -lines 2)

	case "$action" in
		"$CONNECT") nmcli connection up "$name" ;;
		"$FORGET") nmcli connection delete "$name" ;;
		*) return 0 ;;
	esac
}

saved_menu() {
	local names choice

	while true; do
		names=$(saved_connections)
		[ -z "$names" ] && return 0

		choice=$(printf '%s\n' "$names" | pick 'Connected:' 'Search connection')

		case "$choice" in
			'') return 0 ;;
			*) saved_actions "$choice" ;;
		esac
	done
}

main_menu() {
	local toggle

	if wifi_enabled; then
		toggle='toggle off'
	else
		toggle='toggle on'
	fi

	# actions first, the scan result last and separated by a divider
	printf '%s\n' "$toggle" "$MANUAL" "$RESCAN" "$CONNECTED" "$DIVIDER" "$(ssid_list)" |
		pick 'Wi-Fi:' 'Search SSID'
}

while true; do
	choice=$(main_menu)

	case "$choice" in
		'') exit 0 ;;
		'toggle on') nmcli radio wifi on ;;
		'toggle off') nmcli radio wifi off ;;
		"$MANUAL") manual_entry ;;
		"$RESCAN") nmcli dev wifi rescan ;;
		"$CONNECTED") saved_menu ;;
		"$DIVIDER") continue ;;
		*) connect_ssid "$choice" ;;
	esac
done
