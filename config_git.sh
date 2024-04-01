#!/bin/bash

 # Prompt for and set Git username
read -p "Enter your git username: " username
git config --global user.name "$username"

# Prompt for and set Git email
read -p "Enter your git email: " email
git config --global user.email "$email"

echo
echo "[Username (Global)] Git username configured as: $username"
echo "[Email (Global)] Git email configured as: $email"
echo
echo "Git username and email configured globally."
echo

# Prompt for asking and setting Git credential
read -p "Do you want to enable Git credential storage [y/n]? " answer
if [ "$answer" == "y" ]; then
    git config --global credential.helper store
    echo "[Credential Storage] Git credential storage enabled."
elif [ "$answer" == "n" ]; then
    echo "[Credential Storage] Git credential storage not enabled. No changes made."
else
    echo "[Credential Storage] Invalid input. Please enter 'y' or 'n'. No changes made."
fi

# Set Git commit editor as VS Code
git config --global core.editor "code --wait"
echo
echo "[Editor (Global)] Git editor configured as VS Code"