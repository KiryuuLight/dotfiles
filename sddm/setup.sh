#!/usr/bin/env bash

green='\033[0;32m'
red='\033[0;31m'
cyan='\033[0;36m'
grey='\033[2;37m'
reset="\033[0m"

SHPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
THEME_NAME="catppuccin-mocha"

install_dependencies () {
    echo -e "${grey}Installing dependencies with 'pacman'...${reset}"
    sudo pacman -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg imagemagick
}

set_avatar () {
    read -p "Do you want to set a user avatar? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Enter username: " username
        read -p "Enter path to image: " image_path
        bash "$SHPATH/change_avatar.sh" "$username" "$image_path"
    fi
}

copy_files () {
    echo -e "${grey}Copying files from '${SHPATH}/' to '/usr/share/sddm/themes/${THEME_NAME}/'...${reset}"
    sudo mkdir -p /usr/share/sddm/themes/${THEME_NAME}
    sudo cp -rf "$SHPATH"/. /usr/share/sddm/themes/${THEME_NAME}/
}

setup_xsetup () {
    echo -e "${grey}Setting up Xsetup script for multi-monitor support...${reset}"
    sudo mkdir -p /usr/share/sddm/scripts
    sudo cp "$SHPATH/scripts/Xsetup" /usr/share/sddm/scripts/Xsetup
    sudo chmod +x /usr/share/sddm/scripts/Xsetup
}

apply_theme () {
    echo -e "${grey}Editing '/etc/sddm.conf'...${reset}"
    if [[ -f /etc/sddm.conf ]]; then
        sudo cp -f /etc/sddm.conf /etc/sddm.conf.bkp
        echo -e "${green}Backup for SDDM config saved in '/etc/sddm.conf.bkp'${reset}"

        if grep -Pzq '\[Theme\]\nCurrent=' /etc/sddm.conf; then
            sudo sed -i '/^\[Theme\]$/{N;s/\(Current=\).*/\1'"${THEME_NAME}"'/;}' /etc/sddm.conf
        else
            echo -e "\n[Theme]\nCurrent=${THEME_NAME}" | sudo tee -a /etc/sddm.conf
        fi

        if ! grep -Pzq 'InputMethod=qtvirtualkeyboard' /etc/sddm.conf; then
            echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a /etc/sddm.conf
        fi

        if ! grep -Pzq "GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/${THEME_NAME}/components/,QT_IM_MODULE=qtvirtualkeyboard" /etc/sddm.conf; then
            echo -e "\n[General]\nGreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/${THEME_NAME}/components/,QT_IM_MODULE=qtvirtualkeyboard" | sudo tee -a /etc/sddm.conf
        fi
    else
        echo -e "[Theme]\nCurrent=${THEME_NAME}" | sudo tee -a /etc/sddm.conf
        echo -e "\n[General]\nInputMethod=qtvirtualkeyboard" | sudo tee -a /etc/sddm.conf
        echo -e "GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/${THEME_NAME}/components/,QT_IM_MODULE=qtvirtualkeyboard" | sudo tee -a /etc/sddm.conf
    fi
}

install_dependencies &&
copy_files &&
apply_theme &&
setup_xsetup &&
set_avatar &&
echo -e "\n${green}Theme successfully installed!${reset}"
