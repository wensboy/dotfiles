#!/usr/bin/env bash

# deine software_packages lists
SOFTWARE_PACKAGES=(
    "neovim"
    "neofetch"
    "zsh"
    "i3wm"
    "rofi"
    "alacritty"
    "stow"
    "picom"
    "polybar"
    "brightnessctl"
    "bluez"
    "bluez-utils"
    "feh"
    "maim"
    "ranger"
    "dunst"
    #what you want to add
)

#define config path
CONFIG_PATH=(
    "ranger"
    "nvim"
    "i3"
    "polybar"
    "rofi"
    "neofetch"
    "picom"
    "alacritty"
    "dunst"
    #~/.config/*
)

#define stow packages
STOW_PACKAGES=(
    "ranger"
    "nvim"
    "i3"
    "polybar"
    "rofi"
    "neofetch"
    "picom"
    "alacritty"
    "dunst"
    #~/.dotfiles/*
)

#change this to match your os
#like:
#pacman/yay -S 
#apt-get install -y
#dnf install -y
#...
COMMAND='pacman -S --noconfirm'

#delete a profile that already exists
echo "Deletes an existing configuration directory..."
for path in "${CONFIG_PATH[@]}";
do
    if [ -d "$HOME/.config/$path" ]
    then
	echo "Removing: ~/.config/$path"
	rm -rf "$HOME/.config/$path"
    else
	echo "Removing: ~/.config/$path not found!"
    fi
done


# update os 
# sudo apt-get upgrade
# sudo dnf upgrade
echo "Updating packages lists..."
sudo pacman -Syu --noconfirm

# install software
echo "Installing packages..."

for package in "${SOFTWARE_PACKAGES[@]}"
do
    if ! pacman -Qi "$package" &>/dev/null;
    then
	echo "Installing: $package..."
	eval "sudo $COMMAND $package"
    else
	echo "$package already exists!"
    fi
done


# clean up no useful dependencies 
echo "CLeaning up dependecies..."
sudo pacman -Sc --noconfirm

# install software complete
echo "--->Installing completed!!!<---"

# create config dir
CREATE_CONFIG_DIR(){
    echo "Create config dir..."
    for config_dir in "$CONFIG_PATH[@]"
    do
	echo "Createing: $config_dir"
	mkdir $HOME/.config/$config_dir
    done
}

# create config link
CREATE_CONFIG_LINK(){
    echo "Create config link..."
    cd $HOME/.dotfiles
    for config_link in "$STOW_PACKAGES[@]"
    do
	if [ -d "$HOME/.dotfiles/$config_link"]
	then
	    echo "Creating: $config_link configuration link..."
	    stow $config_link -t "$HOME/.config/$config_link"
	else
	    echo "Creating: $config_link not found!"
	fi
    done
}

# Execute functions

main(){
    echo "--->LINK<---"
    CREATE_CONFIG_DIR
    CREATE_CONFIG_LINK
}

main
