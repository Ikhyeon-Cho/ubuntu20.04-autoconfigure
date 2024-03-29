# Auto-configuration of ROS Developer Settings in Ubuntu 20.04
The repository provides the `Installation shell scripts` with the basic settings for developing ROS packages. After the first installation (or re-installation, f**k) of Ubuntu 20.04 (Focal Fosa), you can use the scripts in this repository to install the applications below.

## Overview
The following softwares are currently supported:

**1. CLI (Command Line Interface) Tools**
  - `terminator` ([GNOME Terminal Emulator](https://gnome-terminator.org/), supporting multiple windows)
  - `zsh` (with [Oh-my-zsh](https://ohmyz.sh/) configuration)
  - `git`
  - `SCM Breeze` (Supporting various [Git shortcuts](https://github.com/scmbreeze/scm_breeze))
  - `curl` / `wget`
  - `gpustat` (`nvidia-smi` [with improved visualization](https://github.com/wookayin/gpustat). Supported on NVIDIA Graphics Devices only)
  - `tree` (Display the directory structure in a tree-like format)


**2. ROS Package Development Tools**
  - [ROS Noetic](https://wiki.ros.org/noetic) 
  - [Visual Studio Code](https://code.visualstudio.com/)
  - `clang-format` (Tool to format C/C++/... code according to a set of rules and heuristics)

**3. Basic Applications**
  - `Google Chrome`
  - `VLC media player`
  - `SimpleScreenRecorder`

**4. Remote Access and Control**
  - `net-tools` (This includes `arp`, `ifconfig`, `netstat`, `rarp`, `nameif` and `route`)
  - `xrdp` ([an open-source Remote Desktop Protocol server](https://www.xrdp.org/))
  - `vino` (VNC server)
  - `openssh-server` (ssh server)

## Installation
All you have to do is to **clone the latest version of this repository into your local directory**.
  ```
  cd ~/Downloads  # nagivate to your local directory
  git clone https://github.com/Ikhyeon-Cho/ubuntu20.04-autoconfigure.git
  ```

## Usage
There are two types of installation.

**1. Using install_all.sh** In order to install the softwares above at once, use the following command:
  ```
  cd ubuntu20.04-autoconfigure
  sudo ./install_all.sh   # Running this script will start installation
  ```
  Note that this command will install many softwares at once. 
  Please ensure you have at least 10GB of free space on your PC. 
  Also, make sure that you are connected in a stable network.

**3. Using install.sh** In order to install the basic utilities with the specific softwares listed above, use the following command:
  ```
  cd ubuntu20.04-autoconfigure
  # Running this script will start installation
  ./install.sh foldername1 foldername2 foldername3 ...   # put the specific foldername arguments such as terminator, zsh
  ```