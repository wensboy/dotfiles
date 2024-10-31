#! /bin/bash

# get Touchpad name
Touch_name=$(xinput list | grep "Touchpad" | awk '{print $3 " " $4 " " $5}')
#echo $Touch_name
enable_tapping="libinput Tapping Enabled"
#xinput list-props "$Touch_name" | grep "$enable_tapping"
xinput set-prop "$Touch_name" "$enable_tapping" 1


