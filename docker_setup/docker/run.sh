#!/bin/bash
DOCKERFILE_NAME="nvidia-cuda.Dockerfile"

#################################################################
#### Usage: ./run.sh {container_name} (default: pytorch-dev) ####
#################################################################

# Base image settings: Use conda search -c pytorch to check valid versions
UBUNTU_VERSION="20.04"
PYTHON_VERSION="3.8"
PYTORCH_VERSION="1.12"
CUDA_VERSION="11.3"
CUDNN_VERSION="8"
IMAGE_NAME="Ikhyeon-Cho/pytorch:$PYTORCH_VERSION-cu$CUDA_VERSION-ubuntu$UBUNTU_VERSION"

# Container settings: Name, port connection and shell
CONTAINER_NAME="${1:-pytorch-dev}"
HOST_PORT=8888
CONTAINER_PORT=8888
SHELL="/bin/zsh"

# Volume settings:
HOST_WORKSPACE_DIR="$HOME/workspace"
HOST_DATA_DIR="/media/ikhyeon/T9_KITTI"

# Exit immediately if a command exits with a non-zero status
set -e

if [ ! -d "$HOST_WORKSPACE_DIR" ]; then
  echo "Host workspace directory does not exist. Creating $HOST_WORKSPACE_DIR..."
  mkdir -p "$HOST_WORKSPACE_DIR"
fi

# Build the Docker image
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
  echo "Image $IMAGE_NAME not found. Building the image..."
  docker build -t $IMAGE_NAME \
    -f "$DOCKERFILE_NAME" . \
    --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" \
    --build-arg PYTHON_VERSION="$PYTHON_VERSION" \
    --build-arg PYTORCH_VERSION="$PYTORCH_VERSION" \
    --build-arg CUDA_VERSION="$CUDA_VERSION" \
    --build-arg CUDNN_VERSION="$CUDNN_VERSION"

  echo "Docker image $IMAGE_NAME built successfully."
else
  echo "Image $IMAGE_NAME already exists. Skipping build."
fi

# Check if the container is already running, if not, run the container
if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
  echo "Container $CONTAINER_NAME is already running."
else
  echo "Starting container $CONTAINER_NAME..."

  docker run -it --name "$CONTAINER_NAME" \
    --gpus all \
    --shm-size=8G \
    -p "$HOST_PORT:$CONTAINER_PORT" \
    -v "$HOST_WORKSPACE_DIR":"/workspace" \
    -v "$HOST_DATA_DIR":"/data" \
    -w "/workspace" \
    "$IMAGE_NAME" \
    "$SHELL"
    
  echo "Container $CONTAINER_NAME started successfully."
fi
