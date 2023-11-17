#!/bin/bash

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
