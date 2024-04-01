#!/bin/bash

source ../functions.sh

echo -e "\033[1;32mInstalling Google Chrome...\033[0m"

# Add Google Chrome repository if it does not already exist
echo -e "  Adding Google Chrome repository...\033[0m"
CHROME_SOURCE_LIST="/etc/apt/sources.list.d/google-chrome.list"
if [ ! -f "$CHROME_SOURCE_LIST" ]; then
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
    update_package_list
else
    echo -e "  \033[33mChrome repository already exists.\033[0m"
fi

# Install Google Chrome
install_package google-chrome-stable
echo -e "\033[1;32mGoogle Chrome has been installed.\033[0m"
