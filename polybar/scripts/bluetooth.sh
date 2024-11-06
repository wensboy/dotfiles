#!/bin/sh

state=$(bluetoothctl devices Connected | awk '{print $3}')

if [[ -z $state ]]
then
    echo " ---"
else
    echo " $state"
fi


