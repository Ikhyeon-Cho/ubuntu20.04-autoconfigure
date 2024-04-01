#!/bin/bash

source ../functions.sh

update_package_list

echo -e "\033[1;32mInstalling media tools...\033[0m"

install_package vlc
install_package simplescreenrecorder

echo -e "\033[1;32mMedia tools have been installed.\033[0m"