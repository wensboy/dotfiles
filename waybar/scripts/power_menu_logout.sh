#!/usr/bin/env bash

# get desktop env
DE=$(echo "$DESKTOP_SESSION")

if [[ -n $DE ]];
then
    if [[ $DE == "hyprland" ]];
    then
	hyprctl dispatch exit
    elif [[ $DE == "sway" ]];
    then
	swaymsg exit
    fi
fi



