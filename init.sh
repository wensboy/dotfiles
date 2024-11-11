#!/usr/bin/env bash

# deine package lists
PACKAGES=()

# update pacman 
echo "Updating packages lists..."
sudo pacman -Syu --noconfirm

# install 
echo "Installing packages..."

for package in "${PACKAGES[@]}"
do
    if ! pacman -Qi "$package" &>/dev/null;
    then
	echo "Installing $package..."
	sudo pacman -S --noconfirm "$package"
    else
	echo "$package is already installed"
    fi
done


# clean up no useful dependencies 
echo "CLeaning up dependecies..."
sudo pacman -Sc --noconfirm

echo "successful! installing complete!"
