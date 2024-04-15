#!/bin/bash

# Copy ROS CLI tools to ~/.ros_tools.sh
src_dir="ros-noetic"
src_file="ros_terminal_tools.sh"

# Destination directory
dest_dir="$HOME"
dest_file=".ros_tools.sh"

# Check if the source file exists
if [ -f "$src_file" ]; then
  # Copy the source file to the destination
  cp "$src_file" "$dest_dir/$dest_file"
  # echo "File '$src_file' copied to '$dest_file' in your home directory."
  # write to ~/.zshrc
  echo >> ~/.zshrc
  echo 'source ~/.ros_tools.sh' >> ~/.zshrc
else
  echo "Error: Source file '$src_file' does not exist."
fi

ROS_DIR="$HOME/ros"
if [ ! -d "$ROS_DIR" ]; then
  mkdir -p "$ROS_DIR"
fi