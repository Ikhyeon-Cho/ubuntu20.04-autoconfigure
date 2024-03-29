#!/bin/bash

# Ask the user for the version of the NVIDIA driver
echo "Enter the version of nvidia-driver you want to install (e.g., 550):"
read driver_version

# Check if the input is empty
if [ -z "$driver_version" ]; then
    echo "No version provided. Exiting..."
    exit 1
fi

# Construct the package name
package_name="nvidia-driver-$driver_version"

# Update the package list: NVIDIA Driver PPA for latest drivers update
echo "Updating package list..."
sudo add-apt-repository ppa:graphics-drivers/ppa && sudo apt update

# Install the specified version of the NVIDIA driver
echo "Installing $package_name..."
sudo apt install -y $package_name

# Check for successful installation
if [ $? -eq 0 ]; then
    echo "$package_name installation successful."
else
    echo "Failed to install $package_name."
fi
