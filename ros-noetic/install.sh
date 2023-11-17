#!/bin/bash

# Install ROS Noetic
echo 'Installing ROS Noetic....'
echo
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
