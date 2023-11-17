#!/bin/bash

# Update package list
sudo apt update

# Install basic utilities
sudo apt install -y curl software-properties-common apt-transport-https wget git

# Install zsh
sudo apt install -y zsh

# Install Oh My Zsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --skip-chsh --unattended

# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Powerline fonts
sudo apt install -y fonts-powerline

# Install Terminator
sudo apt install -y terminator

# Install net-tools and VNC server
sudo apt install -y net-tools vino

# Install Visual Studio Code using Snap
sudo snap install code --classic

# Install ROS Noetic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update && sudo apt install -y ros-noetic-desktop-full
echo "source /opt/ros/noetic/setup.zsh" >> ~/.zshrc

# Install rosdep
sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
sudo apt install -y python3-rosdep
sudo rosdep init
rosdep update

# Install some additional ROS packages
sudo apt install -y python3-catkin-tools ros-noetic-jsk-visualization ros-noetic-grid-map ros-noetic-tf2-sensor-msgs ros-noetic-move-base-msgs

# Install Google Chrome
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' 
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo apt update && sudo apt install google-chrome-stable

# Install SCM Breeze
git clone https://github.com/scmbreeze/scm_breeze.git ~/.scm_breeze && ~/.scm_breeze/install.sh

# Setting zsh as a default shell and Restart your shell
chsh -s $(which zsh) "$USER" && exec zsh
