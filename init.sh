#!/usr/bin/env bash

#------------------------------------------------------------------------------------common
#===> variable 
AUR='yay'
CONFIG_DIR='$HOME/.config'

#===> packages from arch pacman 

pacman_packages=()

#===> packages from AUR(yay,paru...) 

aur_packages=()

#===> make sure at $HOME dir currently 

cd $HOME

#===> start install function 

Start_install(){
    echo "[Start_install]===> $1"
}

#===> finish install function 

Finish_install(){
    echo "[Finish_install]===> $1"
}

#===> Confirm install function
Confirm_install(){
    while true;do
	read -p "[Confirm_install]===> $1? [y/n] " confirm_state
	if [[ ${confirm_state} == "y" ]]; then
		return 0
	elif [[ ${confirm_state} == "n" ]]; then
		return 1
	else
		echo "[Invalid]===> value: $confirm_state"	
	fi
    done
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
    Finish_install "$AUR"
}

#------------------------------------------------------------------------------------install aur

#------------------------------------------------------------------------------------select a wm

#===> variable

#===> lists of wm
Window_Managers=(
    "i3-wm"
    "sway"
    "hyprland"
)

Print_All_Window_Manager(){
    count=1
    echo "--------------------------------------------------"
    for wm in ${Window_Managers[@]}
    do
	echo "[$count] $wm" 
	(( count++ ))
    done
    echo "--------------------------------------------------"
}

Select_Window_Manager(){
   Print_All_Window_Manager
   while true;do
   read -p "[Select_wm]===> [1-${#Window_Managers[@]}]  " selected_wm
   if [[ -n ${selected_wm} ]]; then
       if [[ ${selected_wm} -ge 1 && ${selected_wm} -le ${#Window_Managers[@]} ]];then
	   selected_code=$(Confirm_install "${Window_Manager[$selected_wm]}") 
	   case $selected_code in
	       0)
		    Start_install "${Window_Manager[$selected_wm]}"
		    sudo pacman -S ${selected_wm} 
		    Finish_install "${Window_Manager[$selected_wm]}"
		    break
		;;
		
	       1)
		    echo "[Back]......"
		;;
	    esac	
       else
	   echo "[Invalid]===> value: ${selected_wm}"
	fi
    else
	echo "[Invalid]===> value: ${selected_wm} required"
   fi
   done
}

#------------------------------------------------------------------------------------select a wm
