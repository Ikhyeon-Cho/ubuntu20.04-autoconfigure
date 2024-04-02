#!/bin/bash

source ../functions.sh

echo -e "\033[1;32mInstalling Docker...\033[0m\n"

# Function to check if Docker is installed
is_docker_installed() {
    docker --version &> /dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Check if Docker is installed, and install it if it's not
if ! is_docker_installed; then
    echo -e "\033[1;32mInstalling Docker...\033[0m\n"

    # Install Docker
    install_package curl
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh

    # Add the current user to the docker group
    sudo groupadd docker 2> /dev/null  # Suppress the error if the group already exists
    sudo usermod -aG docker $USER

    echo -e "\033[1;32mDocker has been installed.\033[0m"
    echo -e "  \033[33mIf docker without [sudo] does not work, please reboot your system.\033[0m\n"
else
    echo -e "\033[1;32mDocker already exists. Skipping Docker installation.\033[0m"
fi

# Install NVIDIA Container Toolkit
# Check if the driver is already installed
DRIVER="nvidia-driver"
DRIVER_VERSION=$(dpkg -l | grep 'nvidia-driver-' | awk '{print $2}' | grep -o 'nvidia-driver-[0-9]\+')
echo -e "\033[1;32mChecking if $DRIVER is installed...\033[0m"
if dpkg -l | grep -qw "$DRIVER"; then
  echo -e "  \033[32m$DRIVER_VERSION found.\033[0m"
  echo -e "\033[1;32mInstalling NVIDIA Container Toolkit...\033[0m\n"

  # Add the NVIDIA Container Toolkit repository
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
  && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
  && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
  
  # Update the package list
  update_package_list
  
  # Install the NVIDIA Container Toolkit
  install_package nvidia-container-toolkit
  install_package nvidia-docker2
  
  # Restart the Docker service
  sudo systemctl restart docker
  
  # Test the NVIDIA Container Toolkit installation
  echo -e "\033[1;32mTesting NVIDIA Container Toolkit installation...\033[0m"
  docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

else
  echo -e "  \033[31m$DRIVER is not installed. Quit the NVIDIA docker container process.\033[0m"
  exit 1
fi

