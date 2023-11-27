#!/bin/bash

# Install basic utilities
sudo apt install -y curl software-properties-common apt-transport-https wget git tree

# Install net-tools and VNC server, XRDP: For Remote Access
sudo apt install -y net-tools vino xrdp openssh-server

# Get the current directory where ubuntu_setup.sh is located
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Execute zsh/install.sh first
if [ -e "$script_dir/zsh/install.sh" ]; then
    echo "Executing zsh/install.sh"
    (cd "$script_dir/zsh" && ./install.sh)
else
    echo "zsh/install.sh not found. Skipping."
fi

# List all directories containing install.sh and execute them
for dir in "$script_dir"/*; do
    if [ -d "$dir" ] && [ -e "$dir/install.sh" ] && [ "$dir" != "$script_dir/zsh" ]; then
        echo "Executing install.sh in $dir"
        (cd "$dir" && ./install.sh)
    fi
done
