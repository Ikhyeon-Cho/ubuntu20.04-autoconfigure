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
### Use sed to replace the content on line 74 of ~/.zshrc
sed -i '74s/.*/'plugins=(zsh-autosuggestions zsh-syntax-highlighting)'/' ~/.zshrc

### Set alias refreshing shell
echo >> ~/.zshrc
echo 'alias sz="exec zsh"' >> ~/.zshrc

# Install Powerline fonts
sudo apt install -y fonts-powerline

# Setting zsh as a default shell
chsh -s $(which zsh) "$USER"
