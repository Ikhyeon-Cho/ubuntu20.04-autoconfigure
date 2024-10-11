docker build -t Ikhyeon/torch-cuda:11.3.1-devel-ubuntu20.04 \
  -f pytorch.Dockerfile . \
  # --build-arg UID=$(id -u) \
  --build-arg UID=1000 \
  --build-arg USER_NAME=$USER \
  --build-arg UBUNTU_VERSION=20.04 \
  --build-arg PYTHON_VERSION=3.8 \
  --build-arg PYTORCH_VERSION=1.12.0 \
  --build-arg CUDA=11.3 \
  --build-arg CUDA_VERSION=11.3.1 \
  --build-arg CUDNN_VERSION=8 \
  --build-arg CONDA_ENV_NAME=conda