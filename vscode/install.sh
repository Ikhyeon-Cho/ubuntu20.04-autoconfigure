#!/bin/bash

source ../functions.sh

echo -e "\033[1;32mInstalling Visual Studio Code...\033[0m"

# Check and install wget and gpg only if they are not installed
which wget &> /dev/null || install_package "wget"
which gpg &> /dev/null || install_package "gpg"

# Add the Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg

# Add the Visual Studio Code repository if it does not already exist
echo 'Adding the Visual Studio Code repository...'
VSCODE_REPO_LIST="/etc/apt/sources.list.d/vscode.list"
if [ ! -f "$VSCODE_REPO_LIST" ]; then
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
else
    echo -e "  \033[33mVisual Studio Code repository already exists.\033[0m"
fi

# Ensure apt-transport-https is installed for HTTPS transport
install_package "apt-transport-https"
echo

update_package_list

# Install Visual Studio Code
install_package code
echo -e "\033[1;32mVisual Studio Code has been installed.\033[0m"