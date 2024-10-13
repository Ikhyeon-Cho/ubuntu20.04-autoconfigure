ARG UBUNTU_VERSION=20.04
ARG CUDA=11.3
ARG CUDA_VERSION=11.3.1
ARG CUDNN_VERSION=8
ARG PYTHON_VERSION=3.6
ARG PYTORCH_VERSION=1.9.0

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}

# Need to be re-declared after the FROM statement
ARG CUDA
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
  # libopencv-dev \
  libopenblas-dev && \
  rm -rf /var/lib/apt/lists/*

# CUDA profiling and library setup
ENV LD_LIBRARY_PATH /usr/local/cuda-${CUDA}/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
  echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && \
  ldconfig

# Create user: Pass UID and USER_NAME at build time
ARG UID=
ARG USER_NAME=
RUN adduser $USER_NAME -u $UID --quiet --gecos "" --disabled-password && \
  echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME && \
  chmod 0440 /etc/sudoers.d/$USER_NAME

# SSH Configuration
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
  echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
  echo "UsePAM no" >> /etc/ssh/sshd_config

# Switch to the user
USER $USER_NAME

# Install Miniconda as user
RUN curl -o $HOME/miniconda.sh -sSL http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  chmod +x $HOME/miniconda.sh && \
  bash $HOME/miniconda.sh -bfp $HOME/miniconda && \
  rm $HOME/miniconda.sh

ENV PATH $HOME/miniconda/bin:$PATH

# Create Conda environment and install packages
ARG CONDA_ENV_NAME=cuda-${CUDA}
RUN $HOME/miniconda/bin/conda update -y conda && \
  $HOME/miniconda/bin/conda create -n ${CONDA_ENV_NAME} python=${PYTHON_VERSION} && \
  $HOME/miniconda/bin/conda config --add channels defaults && \
  $HOME/miniconda/bin/conda install -n ${CONDA_ENV_NAME} -c conda-forge jupyterlab && \
  $HOME/miniconda/bin/conda install -n ${CONDA_ENV_NAME} pytorch=${PYTORCH_VERSION} torchvision torchaudio cudatoolkit=${CUDA} -c pytorch

# Install Oh My Zsh and zsh plugins
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended && \
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> ~/.zshrc && \
  echo "source ~/.oh-my-zsh/oh-my-zsh.sh" >> ~/.zshrc && \
  echo "source $HOME/miniconda/bin/activate" >> ~/.zshrc && \
  echo "source activate ${CONDA_ENV_NAME}" >> ~/.zshrc && \
  # Add GPU check to .zshrc
  echo "python -c \"import torch; \
  print(f'\n# of GPUs: {torch.cuda.device_count()}'); \
  print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.device_count() > 0 else None}'); \
  print(f'CUDA Availability in pytorch: {torch.cuda.is_available()}\n')\"" >> ~/.zshrc