#!/bin/bash

source ../functions.sh

update_package_list

echo -e "\033[1;32mInstalling terminal setup...\033[0m"

# Install zsh and set as default shell
echo -e "\033[32mInstalling zsh...\033[0m"
install_package zsh

# Check if zsh is already the default shell
if [ "$(getent passwd $(whoami) | cut -d: -f7)" != "$(which zsh)" ]; then
    echo "Setting zsh as the default shell..."
    sudo usermod -s "$(which zsh)" "$(whoami)"
else
    echo -e "  \033[33mzsh is already the default shell.\033[0m"
fi

# Install Oh My Zsh
echo -e "\033[32mInstalling Oh My Zsh...\033[0m"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
else
    echo -e "  \033[33mOh My Zsh is already installed.\033[0m"
fi

# Install Oh My Zsh plugins
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
echo "Activating oh-my-zsh plugins..."
sed -i '74s/.*/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo -e "\033[32mInstalling additional packages...\033[0m"
install_package fonts-powerline
install_package tree
install_package clang-format

# Install terminator
echo -e "\033[32mInstalling terminator...\033[0m"
install_package terminator

# Copy Config files
source_file="config"
destination_dir="$HOME/.config/terminator"

if [ ! -d "$destination_dir" ]; then
    mkdir -p "$destination_dir"
fi

cp "$source_file" "$destination_dir/"
echo "  config file copied to $destination_dir"

# Install scm breeze
echo -e "\033[32mInstalling SCM Breeze...\033[0m"

# Define variables
SCM_BREEZE_INSTALL_DIR="$HOME/.scm_breeze"
SCM_BREEZE_REPO="https://github.com/scmbreeze/scm_breeze.git"
SCM_BREEZE_INIT_STRING="# SCM Breeze setup"

# Determine which shell configuration file to use
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"
else
    echo "  Unsupported shell. Only Bash and Zsh are supported. Quitting."
    exit 1
fi

# Install SCM Breeze
if [ ! -d "$SCM_BREEZE_INSTALL_DIR" ]; then
    git clone "$SCM_BREEZE_REPO" "$SCM_BREEZE_INSTALL_DIR" && bash "$SCM_BREEZE_INSTALL_DIR/install.sh"
else
    echo -e "  \033[33mSCM Breeze already installed.\033[0m"
fi
# Prepare the silenced exec_string
exec_string="$SCM_BREEZE_INIT_STRING\n[ -s \"$SCM_BREEZE_INSTALL_DIR/scm_breeze.sh\" ] && source \"$SCM_BREEZE_INSTALL_DIR/scm_breeze.sh\" > /dev/null 2>&1"
# Remove the existing SCM Breeze setup line, if any
sed -i "/$SCM_BREEZE_INIT_STRING/d" "$SHELL_CONFIG_FILE"
# Append the new, silenced exec_string to the shell config file
echo -e "$exec_string" >> "$SHELL_CONFIG_FILE"

echo -e "\033[1;32mTerminal setup has been done.\033[0m"