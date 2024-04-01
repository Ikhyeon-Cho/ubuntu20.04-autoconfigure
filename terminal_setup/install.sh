#!/bin/bash

source ../functions.sh

update_package_list

echo -e "\033[1;32mInstalling terminal setup...\033[0m"

# Install zsh and set as default shell
install_package zsh

# Check if zsh is already the default shell
if [ "$(getent passwd $(whoami) | cut -d: -f7)" != "$(which zsh)" ]; then
    echo "Setting zsh as the default shell..."
    sudo usermod -s "$(which zsh)" "$(whoami)"
else
    echo -e "  \033[33mzsh is already the default shell.\033[0m"
fi

# Install Oh My Zsh
echo
echo -e "\033[32mInstalling Oh My Zsh...\033[0m"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
else
    echo -e "  \033[33mOh My Zsh is already installed.\033[0m"
fi

# Install Oh My Zsh plugins
echo
echo -e "\033[32mInstalling Oh My Zsh plugins...\033[0m"
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo -e "  \033[33mzsh-autosuggestions is already installed.\033[0m"
fi

if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo -e "  \033[33mzsh-syntax-highlighting is already installed.\033[0m"
fi

# Activate Zsh plugins
echo
echo "Activating oh-my-zsh plugins..."
sed -i '74s/.*/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo
echo -e "\033[32mInstalling additional packages...\033[0m"
install_package fonts-powerline
install_package tree
install_package clang-format

# Install terminator
echo -e "\033[32mInstalling terminator...\033[0m"
install_package terminator

echo -e "\033[1;32mTerminal setup has been done.\033[0m"