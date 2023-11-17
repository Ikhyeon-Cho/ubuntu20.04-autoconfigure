#!/bin/bash

# Install Terminator
echo 'Installing Terminator....'
echo
sudo apt install -y terminator

# Copy Config files
source_file="config"
destination_dir="$HOME/.config/terminator"

if [ -d "$destination_dir" ]; then
    cp "$source_file" "$destination_dir/"
    echo "Config file copied to $destination_dir"
else
    echo 'No $destination_dir exists! Failed to copy terminator config.'
fi


