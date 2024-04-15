# Auto-configuration of ROS Developer Settings in Ubuntu 20.04
The repository provides the `bash scripts` that configures the basic settings for developing ROS packages. After the first installation (or re-installation) of Ubuntu 20.04 (Focal Fosa), you can use the scripts in this repository to install the applications all at once.

## Overview
The following softwares are currently supported:

**1. Essential Command-line Interface (CLI) Tools:**
  - `git`
  - `curl` / `wget` / `gpg`
  - `build-essential`
  - `PGP` (`apt-transport` / `software-properties-common`)

**2. Common Applications:**
  - `Google Chrome`
  - `Visual Studio Code`
  - `VLC media player`
  - `Simple Screen Recorder`
  - `terminator` ([GNOME Terminal Emulator](https://gnome-terminator.org/), supporting multiple CLI windows)  

**3. Shell Environment Configuration:** 
  - `zsh` (with [Oh-my-zsh](https://ohmyz.sh/) configuration)
  - `SCM Breeze` (Supporting various [Git shortcuts](https://github.com/scmbreeze/scm_breeze))
  - `tree` (Display the directory structure in a tree-like format)

**4. ROS:**
  - [ROS Noetic](https://wiki.ros.org/noetic) 
  - `clang-format` (C/C++ Formatter according to a set of rules and heuristics)
  - `velodyne ROS driver` (Velodyne ROS driver)
  - `realsense2 SDK & ROS driver` (Realsense SDK, ROS driver)

**5. Remote Access and Communication:**
  - `net-tools` (This includes `arp`, `ifconfig`, `netstat`, `rarp`, `nameif` and `route`)
  - `xrdp` ([an open-source Remote Desktop Protocol server](https://www.xrdp.org/))
  - `vino` (VNC server)
  - `openssh-server` (ssh server)

**6. NVIDIA Driver:**
  - Automatic update of `pciids` and the latest nvidia-driver lists
  - Interactive installation
  - `gpustat` (`nvidia-smi` [with improved visualization](https://github.com/wookayin/gpustat). Supported on NVIDIA GPUs only)

**7. Docker Installation and Configuration:**


## Prerequisites
All you have to do is to **clone the latest version of this repository into your local directory**.
  ```
  cd ~/Downloads  # nagivate to your local directory
  git clone https://github.com/Ikhyeon-Cho/ubuntu20.04-autoconfigure.git
  ```

## Basic Usage
There are two types of installation.

**1. Install the softwares ALL AT ONCE:** use the following command:
  ```
  cd ubuntu20.04-autoconfigure
  ./install.sh   # Running this script will start installation
  ```
  Note that this command will install many softwares at once. Please ensure you have at least 10GB of free space on your PC. Also, make sure that you are connected in a stable network.

**3. Install each softwares seperately:** In order to install the each utilities, use the following command:
  ```
  # Navigate to the sub folder
  cd ubuntu20.04-autoconfigure/{folder-to-install}  # i.e. cd ubuntu20.04-autoconfigure/chrome
  ./install.sh   # Running this script will start installation
  ```