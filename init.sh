#!/usr/bin/env bash

#===> packages from arch pacman
pacman_packages=()

#===> packages from AUR(yay,paru...)
aur_packages=()
AUR=yay

#===> make sure at $HOME dir currently
cd $HOME

#===> start install function
Start_install(){
    echo "[Start_install]===> $1"
}

#===> Complete install function
Complete_install(){
    echo "[Complete_install]===> $1"
}


#===> install aur
Install_AUR(){
    Start_install $AUR
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/$AUR.git
    cd $AUR
    makepkg -si     
    Complete_install $AUR
}




