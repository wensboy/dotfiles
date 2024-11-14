#!/bin/bash

brightness=$(brightnessctl | awk '{match($0,/\(.*?\)/,arr);print arr[0]}')

brightness=$(echo $brightness | tr -d '()')
state=$(echo $brightness | tr -d '%')

if [[ $state -le 20 ]]
then
    echo " $brightness"
else
    echo " $brightness"
fi

