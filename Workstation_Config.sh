#!/usr/bin/env bash
########################### Start Safe Header ##################################
#Developed by Alex Umansky aka TheBlueDrara
#Purpose: Download configure and back up neccery tools for a new workstation
#Date: 15.2.2025
set -o errexit
set -o pipefail
set -o nounset
########################### End Safe Header ####################################


function main() {

    echo " checking if nececry tools exist..."
    vim_check
    ide_install
}


function vim_check(){

    echo " checking if vim exists in system"
    if dpkg -l | grep -q '^ii  vim '; then
	echo "vim already exists in system"
    else
	echo "vim not found, installing vim..."
        download_vim
    fi
}


function download_vim(){

    sudo apt-get update && sudo apt-get install vim -y
	touch ~/.vimrc
        cat << EOF >> ~/.vimrc
set shiftwidth=4
set expandtab
set autoindent
set ts=4
syntax enable
set showmatch
EOF
	backup_config
}


function backup_config(){
    
    echo "backing the vim config to ~/Desktop/Configbackup"	
    mkdir -p ~/Desktop/Configbackup 
    cp ~/.vimrc ~/Desktop/Configbackup
    echo "Done"
}


function ide_install(){

    echo " installing codium..."
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

sudo apt update && sudo apt install codium -y
    echo " installtion complete"
}

main
