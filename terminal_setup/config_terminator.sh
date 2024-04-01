#!/bin/bash

# Copy Config files

echo -e "\033[32mCopying terminator config file...\033[0m"

source_file="config"
destination_dir="$HOME/.config/terminator"

if [ ! -d "$destination_dir" ]; then
    mkdir -p "$destination_dir"
fi

cp "$source_file" "$destination_dir/"

echo -e "\033[32mTerminator config file copied to $destination_dir\033[0m"