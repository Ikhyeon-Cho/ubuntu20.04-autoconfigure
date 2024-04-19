#!/bin/bash

source ../functions.sh

echo -e "\033[1;32mInstalling NVIDIA driver...\033[0m\n"

# Print the NVIDIA GPU model to help identify which driver might be needed.
echo -e "  \033[32mDetecting NVIDIA GPU...\033[0m"
sudo update-pciids
lspci | grep VGA | awk '{print "\033[33m" $0 "\033[39m"}'

# Check if the driver is already installed
DRIVER="nvidia-driver"
DRIVER_VERSION=$(dpkg -l | grep 'nvidia-driver-' | awk '{print $2}' | grep -o 'nvidia-driver-[0-9]\+')
echo -e "\033[1;32mChecking if $DRIVER is installed...\033[0m"
if dpkg -l | grep -qw "$DRIVER"; then
  echo -e "  \033[32m$DRIVER_VERSION is already installed.\033[0m"
  nvidia-smi
else
  echo -e "  \033[32m$DRIVER is not installed.\033[0m"

  # Get the latest NVIDIA driver list
  echo -e "\033[32mUpdating NVIDIA driver list...\033[0m"
  PPA_NAME="graphics-drivers/ppa"
  PPA_SEARCH_RESULT=$(grep -Rl "$PPA_NAME" /etc/apt/sources.list.d/)
  if [ -z "$PPA_SEARCH_RESULT" ]; then
    echo -e "  \033[32mAdding PPA: $PPA_NAME...\033[0m"
    sudo add-apt-repository ppa:graphics-drivers/ppa
  else
    echo -e "  \033[33m$PPA_NAME is already there. The latest driver lists are available.\033[0m"
  fi
  update_package_list
  echo -e "\033[32mSearching for NVIDIA driver versions...\033[0m"
  # apt-cache search nvidia-driver | grep -E "^nvidia-driver-[0-9]+"
  ubuntu-drivers devices

  # Prompt the user to choose the desired NVIDIA driver version.
  echo -e "\033[33mPlease enter the version of the NVIDIA driver you wish to install (e.g., 470, 525-open): \033[0m"
  read driver_version
  echo -e "\033[32mInstalling NVIDIA driver version: nvidia-driver-$driver_version...\033[0m"
  sudo apt install -y nvidia-driver-$driver_version
  echo -e "\033[32mInstallation complete. Verifying installation...(nvidia-smi)\033[0m"
  nvidia-smi
fi
echo -e "\033[1;32mNVIDIA driver has been installed.\033[0m\n"

# Install gpu tools
echo -e "\033[1;32mInstalling gpustat...\033[0m"
install_package python3-pip
# pip install --user gpustat && echo && gpustat && echo
install_package gpustat
echo -e "\033[1;32mgpustat has been installed.\033[0m\n"
