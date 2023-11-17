#!/bin/bash

# Install Terminator
echo 'Installing Terminator....'
echo
sudo apt install -y terminator

# Copy Config files
source_file="config"
destination_dir="$HOME/.config/terminator"

if [ ! -d "$destination_dir" ]; then
    mkdir -p "$destination_dir"
fi

cp "$source_file" "$destination_dir/"
echo "Config file copied to $destination_dir"

