#!/usr/bin/env bash


morning_wp=~/Pictures/wallpapers/yuanshan01.png
afternoon_wp=~/Pictures/wallpapers/bluebeach.png
dawn_wp=~/Pictures/wallpapers/cloud.png

opts="--transition-type random --transition-fps 90 --transition-step 5"

# kill exist swww-daemon
swww kill
swww-daemon

# get current time
cur=$(date +%H)

case $cur in
	00 | 01 | 02 | 03 | 04 | 05 | 06 | 07) 
    	        swww img $morning_wp $opts
		;;
	08 | 09 | 10 | 11 | 12 | 13 | 14 | 15) 
		swww img $afternoon_wp $opts
		;;
	16 | 17 | 18 | 19 | 20 | 21 | 22 | 23) 
		swww img $dawn_wp $opts
		;;
esac


