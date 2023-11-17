#!/bin/bash

# Install SCM Breeze
echo 'Installing SCM Breeze....'
echo

# Install SCM Breeze
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze && ~/.scm_breeze/install.sh

 # Prompt for and set Git username
read -p "Enter your git username: " username
git config --global user.name "$username"

# Prompt for and set Git email
read -p "Enter your git email: " email
git config --global user.email "$email"

echo
echo "Git username configured as: $username"
echo "Git email configured as: $email"
echo "Git username and email configured globally."

# Prompt for asking and setting Git credential
read -p "Do you want to enable Git credential storage [y/n]? " answer
if [ "$answer" == "y" ]; then
    git config --global credential.helper store
    echo "Git credential storage enabled."
elif [ "$answer" == "n" ]; then
    echo "Git credential storage not enabled. No changes made."
else
    echo "Invalid input. Please enter 'y' or 'n'. No changes made."
fi
