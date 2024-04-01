#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l "$1" &> /dev/null
}

# Function to install a package if not already installed
install_package() {
    echo -e "\033[32mInstalling $1...\033[0m"
    local package="$1"
    if is_installed "$package"; then
        echo -e "  \033[33m$package is already installed.\033[0m"
    else
        sudo apt install -y -qq "$package"
    fi
}

update_package_list() {
    echo -e "\033[1;32mUpdating package list...\033[0m"
    sudo apt update -y
    echo
}