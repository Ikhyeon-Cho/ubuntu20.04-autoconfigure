# PyTorch Development Environment with Docker

Docker configuration for setting up a PyTorch development environment with CUDA support.

## Prerequisites

- NVIDIA GPU with compatible drivers
- Docker installed on your system
- NVIDIA Container Toolkit installed

## Quick Start

1. Clone this repository
2. Run the setup script:
```bash
./run.sh [container_name]
```
The container name is optional - it defaults to "pytorch-dev" if not specified.

## Features

- CUDA and cuDNN support
- PyTorch pre-installed via conda
- Choice of shell (zsh with Oh My Zsh or bash)
- X11 forwarding for GUI applications
- Workspace and data volume mounting
- SSH server configured
- CUDA profiling tools included

## Configuration

### Base Image Settings
Edit `run.sh` to modify these parameters:

- `CUDA_VERSION`: CUDA version (default: 11.8.0)
- `CUDNN_VERSION`: cuDNN version (default: 8)
- `UBUNTU_VERSION`: Ubuntu version (default: 20.04)
- `PYTORCH_VERSION`: PyTorch version (default: 2.0.1)
- `PYTHON_VERSION`: Python version (default: 3.10)

### Container Settings

- `CONTAINER_NAME`: Name of your container (default: pytorch-dev)
- `SHELL`: Default shell (`/bin/zsh` or `/bin/bash`)
- `HOST_WORKSPACE_DIR`: Host directory to mount as workspace
- `HOST_DATA_DIR`: Host directory to mount as data volume

## Volume Mounts

The container automatically mounts:
- `~/workspace` → `/workspace` (working directory)
- Your specified data directory → `/data`

## Shell Configuration

The environment supports two shell options:
- `zsh` with Oh My Zsh (default)
  - Includes autosuggestions and syntax highlighting plugins
- `bash`

## Usage Examples

1. Start with default settings:
```bash
./run.sh
```

2. Start with custom container name:
```bash
./run.sh my-pytorch-container
```

3. If the container exists, the script will:
   - Start the existing container if it's stopped
   - Attach to the container if it's running

## Notes

- The container preserves its state between sessions
- X11 forwarding is automatically configured for GUI applications
- The workspace directory is created automatically if it doesn't exist
- CUDA libraries are properly configured in the container's PATH
