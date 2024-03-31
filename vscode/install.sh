#!/bin/bash

source ../functions.sh

echo -e "\033[35mInstalling Visual Studio Code...\033[0m"

# Check and install wget and gpg only if they are not installed
which wget &> /dev/null || ensure_apt_installed "wget"
which gpg &> /dev/null || ensure_apt_installed "gpg"

# Add the Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm -f packages.microsoft.gpg

# Add the Visual Studio Code repository if it does not already exist
echo '  Adding the Visual Studio Code repository...'
VSCODE_REPO_LIST="/etc/apt/sources.list.d/vscode.list"
if [ ! -f "$VSCODE_REPO_LIST" ]; then
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
else
    echo -e "  \033[33mVisual Studio Code repository already exists.\033[0m"
fi

# Ensure apt-transport-https is installed for HTTPS transport
ensure_apt_installed "apt-transport-https"

# Install Visual Studio Code
echo '  Updating package lists...'
sudo apt-get update -qq
echo '  Installing Visual Studio Code...'
ensure_apt_installed "code"
