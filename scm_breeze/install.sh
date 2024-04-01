#!/bin/bash

echo -e "\033[1;32mInstalling scm breeze...\033[0m"

# Define variables
SCM_BREEZE_INSTALL_DIR="$HOME/.scm_breeze"
SCM_BREEZE_REPO="https://github.com/scmbreeze/scm_breeze.git"
SCM_BREEZE_INIT_STRING="# SCM Breeze setup"

# Determine which shell configuration file to use
SHELL_CONFIG_FILE="$HOME/.zshrc" # Default to Zsh
if which zsh &> /dev/null; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
elif which bash &> /dev/null; then
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

echo -e "\033[1;32mSCM Breeze has been installed.\033[0m"