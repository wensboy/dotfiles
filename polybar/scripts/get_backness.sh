#!/bin/bash

brightness=$(brightnessctl | awk '{match($0,/\(.*?\)/,arr);print arr[0]}')

echo $brightness
