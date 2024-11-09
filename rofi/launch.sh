#!/usr/bin/env bash

#############################
###########style lists#######
#############################

# nord.rasi
# type_four_style_one

dir="$HOME/.config/rofi/themes"
theme='type_four_style_one'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
