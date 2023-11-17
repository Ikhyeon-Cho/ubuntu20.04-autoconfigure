#!/bin/bash

# Install zsh
echo 'Installing Zsh (Including Oh-my-zsh and plugins)....'
echo
sudo apt install -y zsh

# Install Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --skip-chsh --unattended

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Powerline fonts
sudo apt install -y fonts-powerline

# Set Config files
echo 'Please go to $HOME/.zshrc and configure file!'
echo
echo 'ZSH_THEME: agnoster'
echo
echo 'plugins: zsh-autosuggestions'
echo '         zsh-syntax-highlighting'
echo

source_file="agnoster.zsh-theme"
destination_dir="$HOME/.oh-my-zsh/themes"

if [ -d "$destination_dir" ]; then
    cp "$source_file" "$destination_dir/"
    echo "Config file copied to $destination_dir"
else
    echo 'No $destination_dir exists! Failed to copy agnoster theme config.'
fi
