#!/usr/bin/env bash


morning_wp="$HOME/github/dotfiles/hypr/wallpapers/sky.png"
afternoon_wp="$HOME/github/dotfiles/hypr/wallpapers/bluebeach.png"
dawn_wp="$HOME/github/dotfiles/hypr/wallpapers/cloud.png"

opts="--transition-type random --transition-fps 90 --transition-step 5"

# kill exist swww-daemon
swww kill
swww-daemon

# get current time
cur=$(date +%H)

case $cur in
	00 | 01 | 02 | 03 | 04 | 05 | 06 | 07) 
		cur_wp=${morning_wp}
		;;
	08 | 09 | 10 | 11 | 12 | 13 | 14 | 15) 
		cur_wp=${afternoon_wp}
		;;
	16 | 17 | 18 | 19 | 20 | 21 | 22 | 23) 
		cur_wp=${dawn_wp}
		;;
esac

swww img ${cur_wp} $opts
wal -i ${cur_wp} > /dev/null

