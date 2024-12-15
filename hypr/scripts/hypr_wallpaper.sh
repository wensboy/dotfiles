#!/usr/bin/env bash


morning_wp=~/Pictures/wallpapers/yuanshan01.png
afternoon_wp=~/Pictures/wallpapers/bluebeach.png
dawn_wp=~/Pictures/wallpapers/cloud.png

swww_opts="--transition-step 5 --transition-fps 60 --transition-type random"

# kill exist swww-daemon
swww kill


# get current time
cur=$(date +%H)

case $cur in
	00 | 01 | 02 | 03 | 04 | 05 | 06 | 07) 
    	        swww-daemon && swww img $morning_wp $swww_opts
		;;
	08 | 09 | 10 | 11 | 12 | 13 | 14 | 15) 
		swww-daemon && swww img $afternoon_wp $swww_opts
		;;
	16 | 17 | 18 | 19 | 20 | 21 | 22 | 23) 
		swww-daemon && swww img $dawn_wp $swww_opts
		;;
esac


