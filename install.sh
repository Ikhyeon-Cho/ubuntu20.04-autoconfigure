#!/bin/bash

# Install basic utilities
sudo apt install -y curl software-properties-common apt-transport-https wget git tree

# Install net-tools and VNC server, XRDP: For Remote Access
sudo apt install -y net-tools vino xrdp

# Get the current directory where ubuntu_setup.sh is located
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if at least one folder argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 folder1 folder2 folder3 ..."
    exit 1
fi

# Iterate over specified folders and execute install.sh in each
for folder in "$@"; do
    folder_path="$script_dir/$folder"
    
    # Check if the specified folder exists and contains an install.sh script
    if [ -d "$folder_path" ] && [ -e "$folder_path/install.sh" ]; then
        echo "Executing install.sh in $folder_path"
        (cd "$folder_path" && ./install.sh)
    else
        echo -e "\e[31m[Error] Folder '$folder' does not exist or does not contain install.sh"
    fi
done

