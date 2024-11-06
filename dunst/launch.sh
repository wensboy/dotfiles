#!/bin/bash

#kill all running dunst
killall -q dunst

#running dunst with new config file
dunst 2>&1 | tee -a /tmp/dunst.log & disown


