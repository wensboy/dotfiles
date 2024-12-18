#!/usr/bin/env bash

# theme directory
theme="$HOME/.config/rofi/applets/share/theme.rasi"

# Theme Elements
prompt='Screenshot'
mesg="DIR: `xdg-user-dir PICTURES`/Screenshots"
list_col='5'
list_row='1'
win_width='670px'

# Options
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Capture Desktop"
	option_2=" Capture Area"
	option_3=" Capture Window"
	option_4=" Capture in 5s"
	option_5=" Capture in 10s"
else
	option_1=""
	option_2=""
	option_3=""
	option_4=""
	option_5=""
fi

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
save=" "
copy=" "
time=$(date +%s)
geometry=`xrandr | grep 'current' | head -n1 | cut -d',' -f2 | tr -d '[:blank:],current'`
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="${time}_${geometry}.png"

if [[ ! -d "$dir" ]]; then
	mkdir -p "$dir"
fi

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'How to deal?' \
		-theme ${theme}
}

# Ask for confirmation
confirm_exit() {
	echo -e "$save\n$copy" | confirm_cmd
}

# Copy screenshot to clipboard
copy_shot () {
    wl-copy < ${dir}/${file}
    rm -f ${dir}/${file}
}

# notify and view screenshot
notify_view() {
	notify_cmd_shot='dunstify -u low --replace=699'
	if [[ -e "$dir/$file" ]]; then
	    confirm=$(confirm_exit)
	    if [[ $confirm == "${save}" ]]; then
		viewnior ${dir}/"$file"
		${notify_cmd_shot} "Screenshot Saved."
	    elif [[ $confirm == "$copy" ]]; then
		copy_shot		
		${notify_cmd_shot} "Copied Into Clipboard."
	    else
		rm -f $dir/$file
		${notify_cmd_shot} "Screenshot Deleted."
	    fi
	else
		${notify_cmd_shot} "Screenshot Deleted."
	fi
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
# TODO: I just think that if i can choose how to deal with the shot here?
# like: save [or] copy in clipboard [have been fixed!!!]
# maybe rofi to achieve...
shotnow () {
    cd ${dir} && sleep 0.5 && grim -t png ${file}
	notify_view
}

shot5 () {
	countdown '5'
	sleep 1 && cd ${dir} && grim -t png ${file}
	notify_view
}

shot10 () {
	countdown '10'
	sleep 1 && cd ${dir} && grim -t png ${file}
	notify_view
}

shotwin () {
	cd ${dir} && maim -u -f png -i `xdotool getactivewindow` ${dir}/${file}
	notify_view
}

shotarea () {
	cd ${dir} && grim -g "$(slurp)" -t png ${file}
	notify_view
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		shotnow
	elif [[ "$1" == '--opt2' ]]; then
		shotarea
	elif [[ "$1" == '--opt3' ]]; then
		shotwin
	elif [[ "$1" == '--opt4' ]]; then
		shot5
	elif [[ "$1" == '--opt5' ]]; then
		shot10
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac


