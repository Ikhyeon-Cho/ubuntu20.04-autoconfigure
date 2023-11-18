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

# Activate Zsh plugins
echo >> ~/.zshrc
echo 'plugins=(zsh-autosuggestions zsh-syntax-highlighting)' >> ~/.zshrc
echo >> ~/.zshrc
echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc
echo >> ~/.zshrc
echo 'alias sz="source ~/.zshrc"' >> ~/.zshrc

# Install Powerline fonts
sudo apt install -y fonts-powerline

# Setting zsh as a default shell
chsh -s $(which zsh) "$USER"
