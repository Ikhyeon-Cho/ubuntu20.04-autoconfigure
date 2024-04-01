#!/bin/bash

source ../functions.sh

update_package_list
echo

echo -e "\033[1;32mInstalling essential packages...\033[0m"
install_package curl
install_package software-properties-common
install_package apt-transport-https
install_package wget
install_package gpg
install_package git
install_package build-essential
echo