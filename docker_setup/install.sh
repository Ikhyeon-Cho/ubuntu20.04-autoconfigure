#!/bin/bash

source ../functions.sh

# Function to check if Docker is installed
is_docker_installed() {
    docker --version &> /dev/null
    if [ $? -eq 0 ]; then
        return 0
    else
        return 1
    fi
}

# Check if Docker is installed, and if not, install it 
if ! is_docker_installed; then
    echo -e "\033[1;32mInstalling Docker...\033[0m\n"

    # Add Docker's official GPG key:
    update_package_list
    install_package ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    update_package_list

    # Install Docker
    install_package docker-ce
    install_package docker-ce-cli
    install_package containerd.io
    install_package docker-buildx-plugin
    install_package docker-compose-plugin

    # Post installation steps
    sudo groupadd docker 2> /dev/null  # Suppress the error if the group already exists
    sudo usermod -aG docker $USER

    # Verify the installation without sudo
    docker run hello-world
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
  echo -e "  \033[32mCheck whether the CUDA version 11.0.3 is successfully printed!!...\033[0m"
  docker run --rm --gpus all nvidia/cuda:11.0.3-base /bin/bash -c 'echo CUDA: $CUDA_VERSION'

else
  echo -e "  \033[31m$DRIVER is not installed. Quit the NVIDIA docker container process.\033[0m"
  exit 1
fi

echo -e "\033[1;32mNeed to log out and log in again, to make docker command available without sudo...\033[0m\n"