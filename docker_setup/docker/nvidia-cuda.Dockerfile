ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=11.3
ARG CUDNN_VERSION=8
ARG PYTHON_VERSION=3.8
ARG PYTORCH_VERSION=1.12

# Configure base image: see https://hub.docker.com/r/nvidia/cuda/tags
FROM nvidia/cuda:${CUDA_VERSION}.1-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}

# Re-declare ARGs after FROM
ARG CUDA_VERSION
ARG PYTHON_VERSION
ARG PYTORCH_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates ccache curl build-essential cmake ninja-build lsb-release gnupg2 sudo \
  python3-pip zsh git wget pkg-config software-properties-common ssh openssh-server unzip vim \
  # For X11 forwarding
  libx11-xcb1 libxcb-{icccm4,image0,keysyms1,randr0,render-util0,shape0,xfixes0,xinerama0,cursor0} libxkbcommon-x11-0 \
  # libopencv-dev \
  python3-opencv \
  libopenblas-dev && \
  rm -rf /var/lib/apt/lists/*

# CUDA profiling and library setup
ENV LD_LIBRARY_PATH /usr/local/cuda-${CUDA_VERSION}/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
  echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && \
  ldconfig

# SSH Configuration
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
  echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
  echo "UsePAM no" >> /etc/ssh/sshd_config

# Install Miniconda
RUN curl -o /root/miniconda.sh -sSL http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  chmod +x /root/miniconda.sh && \
  bash /root/miniconda.sh -bfp /root/miniconda && \
  rm /root/miniconda.sh

ENV PATH /root/miniconda/bin:$PATH

# Create Conda environment and install packages
ARG CONTAINER_NAME
ARG CONDA_ENV_NAME=${CONTAINER_NAME:-cuda-${CUDA_VERSION}}
RUN /root/miniconda/bin/conda update -y conda && \
  /root/miniconda/bin/conda create -n ${CONDA_ENV_NAME} python=${PYTHON_VERSION} && \
  /root/miniconda/bin/conda config --add channels defaults && \
  /root/miniconda/bin/conda install -n ${CONDA_ENV_NAME} -c conda-forge jupyterlab && \
  /root/miniconda/bin/conda install -n ${CONDA_ENV_NAME} pytorch=${PYTORCH_VERSION} torchvision torchaudio cudatoolkit=${CUDA_VERSION} -c pytorch

# (Optional) Install Oh My Zsh and zsh plugins
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> /root/.zshrc && \
  echo "source ~/.oh-my-zsh/oh-my-zsh.sh" >> /root/.zshrc && \
  echo "source /root/miniconda/bin/activate" >> /root/.zshrc && \
  echo "conda activate ${CONDA_ENV_NAME}" >> /root/.zshrc && \
  # Check: print GPU info at execution
  echo "python -c \"import torch; \
  print(f'# of GPUs: {torch.cuda.device_count()}'); \
  print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.device_count() > 0 else None}'); \
  print(f'CUDA availability in Pytorch: {torch.cuda.is_available()}\n')\"" >> /root/.zshrc
CMD ["/bin/zsh"]