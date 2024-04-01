#!/bin/bash

# Get the current directory where ubuntu_setup.sh is located
project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Execute essentials/install.sh first
cd $project_dir/essentials && ./install.sh && echo

cd $project_dir/chrome && ./install.sh && echo

cd $project_dir/vscode && ./install.sh && echo

cd $project_dir/media_tools && ./install.sh && echo

cd $project_dir/remote_setup && ./install.sh && echo

cd $project_dir/terminal_setup && ./install.sh && echo

cd $project_dir/ros-noetic && ./install.sh && echo

cd $project_dir/scm_breeze && ./install.sh && echo