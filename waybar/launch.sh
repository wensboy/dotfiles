#! /bin/bash

# kill the running bar
killall -q waybar
# use ipc
# polybar-msg cmd quit


# running polybar with default config
waybar & 2>&1 | tee -a /tmp/waybar.log & disown
