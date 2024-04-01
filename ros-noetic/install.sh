#!/bin/bash

source ../functions.sh

echo -e "\033[1;32mInstalling ROS Noetic...\033[0m"

# Add the ROS repository if it does not already exist
ROS_SOURCE_LIST="/etc/apt/sources.list.d/ros-latest.list"
if [ ! -f "$ROS_SOURCE_LIST" ]; then
    sudo sh -c "echo 'deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main' > $ROS_SOURCE_LIST"
    # Import the repository key silently
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    update_package_list
else
    echo -e "  \033[33mROS repository already exists.\033[0m"
fi

# Install ROS Noetic
install_package ros-noetic-desktop-full

# Append ROS environment setup to the shell configuration file, if not already present
SHELL_CONFIG_FILE="$HOME/.bashrc" # Default to .bashrc
if [ -n "$ZSH_VERSION" ]; then
   SHELL_CONFIG_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
   SHELL_CONFIG_FILE="$HOME/.bashrc"
else
   echo "Unknown shell. Please add 'source /opt/ros/noetic/setup.sh' manually to your shell's config file. Quitting."
   exit 1
fi
grep -qxF 'source /opt/ros/noetic/setup.sh' "$SHELL_CONFIG_FILE" || echo "source /opt/ros/noetic/setup.sh" >> "$SHELL_CONFIG_FILE"

# Install rosdep dependencies
install_package python3-rosdep
install_package python3-rosinstall
install_package python3-rosinstall-generator
install_package python3-wstool
install_package build-essential

echo -e "\n\033[1;32mUpdating rosdep...\033[0m"
# Initialize rosdep
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
   sudo rosdep init
fi
rosdep update

# Install some additional ROS packages
install_package python3-catkin-tools
install_package ros-noetic-jsk-visualization
install_package ros-noetic-tf2-sensor-msgs
install_package ros-noetic-costmap-2d
install_package ros-noetic-move-base-msgs
install_package ros-noetic-ddynamic-reconfigure
install_package ros-noetic-map-server
install_package ros-noetic-teleop-twist-keyboard
install_package ros-noetic-teleop-twist-joy
install_package ros-noetic-grid-map
install_package ros-noetic-grid-map-rviz-plugin
install_package ros-noetic-nmea-msgs
install_package ros-noetic-mavros-msgs
install_package libpcap-dev