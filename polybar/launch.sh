#! /bin/bash

# kill the running bar
killall -q polybar
# use ipc
# polybar-msg cmd quit


# running polybar with default config
polybar i3-polybar 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar launched"
