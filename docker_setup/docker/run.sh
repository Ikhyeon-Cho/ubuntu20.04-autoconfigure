#!/bin/bash
DOCKERFILE_NAME="nvidia-cuda.Dockerfile"

#################################################################
#### Usage: ./run.sh {container_name} (default: pytorch-dev) ####
#################################################################

## Base image settings
# Check your CUDA and GPU product compatibility at:
# https://forums.developer.nvidia.com/t/cuda-compatibility-between-nvidia-rtx-a5000-and-geforce-rtx-4060-ti/264216
CUDA_VERSION="11.8.0"
CUDNN_VERSION="8"
UBUNTU_VERSION="20.04"
# Use conda search -c pytorch | grep {cuda-version} to check compatible conda PyTorch versions
PYTORCH_VERSION="2.0.1"
PYTHON_VERSION="3.10"
IMAGE_NAME="Ikhyeon-Cho/pytorch:$PYTORCH_VERSION-cu$CUDA_VERSION-ubuntu$UBUNTU_VERSION"

## Container settings: Name, Shell, and Volumes
CONTAINER_NAME="${1:-pytorch-dev}"
SHELL="/bin/zsh"
HOST_WORKSPACE_DIR="$HOME/workspace"
HOST_DATA_DIR="/media/ikhyeon/T9_KITTI"

## Exit immediately if a command exits with a non-zero status
set -e

if [ ! -d "$HOST_WORKSPACE_DIR" ]; then
  echo -e "\033[33mHost workspace directory does not exist. Creating $HOST_WORKSPACE_DIR...\033[0m"
  mkdir -p "$HOST_WORKSPACE_DIR"
fi

## Build the Docker image
echo -e "\033[33mImage: $IMAGE_NAME\033[0m"
echo -e "\033[33mContainer: $CONTAINER_NAME\033[0m"
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo -e "\033[33mImage not found. Building the image...\033[0m"
  docker build -t $IMAGE_NAME \
    -f "$DOCKERFILE_NAME" . \
    --build-arg PYTORCH_VERSION="$PYTORCH_VERSION" \
    --build-arg CUDA_VERSION="$CUDA_VERSION" \
    --build-arg CUDNN_VERSION="$CUDNN_VERSION" \
    --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" \
    --build-arg CONTAINER_NAME="$CONTAINER_NAME" \
    --build-arg PYTHON_VERSION="$PYTHON_VERSION"
  echo -e "\033[32mDocker image $IMAGE_NAME built successfully.\033[0m"
else
  echo -e "\033[32mImage already exists. Skipping building...\033[0m"
fi

## Allow Docker to access the host X server
## Restore the access permissions after the script exits
xhost +local:docker > /dev/null 2>&1
trap 'xhost -local:docker > /dev/null 2>&1' EXIT

## Check if the container is already running, if not, run the container
if [[ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]]; then
  echo -e "\033[32mContainer already exists.\033[0m"
  echo -e "\033[33mStarting the container...\033[0m"
  docker start "$CONTAINER_NAME"
  docker exec -it "$CONTAINER_NAME" "$SHELL"
else
  echo -e "\033[33mCreating container \"$CONTAINER_NAME\"...\033[0m"

  docker run -it --name "$CONTAINER_NAME" \
    --gpus all \
    --shm-size=8G \
    -e DISPLAY=$DISPLAY \
    -e XDG_RUNTIME_DIR=/tmp \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --net host \
    -v "$HOST_WORKSPACE_DIR":"/workspace" \
    -v "$HOST_DATA_DIR":"/data" \
    -w "/workspace" \
    "$IMAGE_NAME" \
    "$SHELL"
    
  echo -e "\033[33mContainer \"$CONTAINER_NAME\" created successfully.\033[0m"
fi