#!/bin/bash

source ../functions.sh

update_package_list

echo -e "\033[1;32mInstalling remote setup packages...\033[0m"
install_package net-tools
install_package vino
install_package xrdp
install_package openssh-server

# Enable remote access while preventing black screen
echo -e "\033[1;32mEnable Remote Access without Black Screen...\033[0m"

XRDP_SESSION_FILE=/etc/xrdp/startwm.sh
echo "  Writing scripts to $XRDP_SESSION_FILE...."
sudo sed -i '32i\unset DBUS_SESSION_BUS_ADDRESS' $XRDP_SESSION_FILE
sudo sed -i '33i\unset XDG_RUNTIME_DIR' $XRDP_SESSION_FILE

COLOR_FILE=/etc/polkit-1/localauthority/50-local.d/color.pkla
echo "  Writing scripts to $COLOR_FILE...."
echo -e "[Allow colord for all users]\nIdentity=unix-user:*\n" | sudo tee $COLOR_FILE > /dev/null
echo -e "Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile\n" | sudo tee -a $COLOR_FILE > /dev/null
echo -e "ResultAny=no\nResultInactive=no\nResultActive=yes" | sudo tee -a $COLOR_FILE > /dev/null

echo "  Restarting xrdp service..."
sudo systemctl restart xrdp
echo '  Done.'
echo -e "\033[1;32mRemote setup packages have been installed.\033[0m"
