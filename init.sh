#!/usr/bin/env bash

#------------------------------------------------------------------------------------common
#===> variable <====================#
AUR='yay'
CONFIG_DIR='$HOME/.config'

#===> packages from arch pacman <====================#

pacman_packages=()

#===> packages from AUR(yay,paru...) <====================#

aur_packages=()

#===> make sure at $HOME dir currently <====================#

cd $HOME

#===> start install function <====================#

Start_install(){
    echo "[Start_install]===> $1"
}

#===> Complete install function <====================#

Complete_install(){
    echo "[Complete_install]===> $1"
}

#------------------------------------------------------------------------------------common

#------------------------------------------------------------------------------------delete config directory
Delete_config_dir(){
    if [[ -d "$CONFIG_DIR/$1" ]]; then
	echo "==================== $1 ===================="
	while true; do
	    read -p "Do you want to delete $CONFIG_DIR/$1?[y/n]" Delete_state
	    if [[ "$Delete_state" == "y" ]]; then
		rm -rf "$CONFIG_DIR/$1"
		break
	    elif [[ "$Delete_state" == "n" ]]; then
		echo "[Reserve_config_dir]===> $CONFIG_DIR/$1"
		break
	    else
		echo "[Error]===> Invalid value: $Delete_state"
	    fi
	done
	echo "[Delete_config_dir]===> $CONFIG_DIR/$1"
	echo "=========================================="
    else
	echo "[Dir_Not_found]===> $CONFIG_DIR/$1"
    fi
}
#------------------------------------------------------------------------------------delete config directory

#------------------------------------------------------------------------------------install aur
# If your AUR fails to install during the installation process
# you can try to find the two most common reasons:
# [1]slow access to go 
# [2]slow access to git
# Identify the problem and uncomment the solution
# If it is a problem with other problems
# Write a solution by yourself 
# Execute the solution before installing AUR

#===> solution of go
Solution_go(){
# Enable the go module
    export GO111MODULE=on
# Just replace it with a source that can be accessed in the corresponding region
    export GOPROXY=https://goproxy.cn
}

#===> solution of git
Solution_git(){
# Access dnschecker and find a git IP that can be accessed normally 
# Replace the following 'found_git_ip' to the git ip
    sudo echo "found_git_ip github.com" >> /etc/hosts 
}

# add your solutions here, just like:
# Solution_<name of problem>(){}

Install_AUR(){
    # Solution_go
    # Solution_git
    Start_install "$AUR"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/$AUR.git
    cd "$AUR"
    makepkg -si     
    Complete_install "$AUR"
}

#------------------------------------------------------------------------------------install aur



