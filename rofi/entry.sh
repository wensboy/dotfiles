#!/usr/bin/env bash

## Author : wensboy
## Github : @wensboy
## Fork: https://github.com/adi1090x/rofi
## Rofi Entry

dir="$HOME/.config/rofi/themes"
theme='default'

rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
