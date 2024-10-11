ARG UBUNTU_VERSION=20.04
ARG CUDA_VERSION=11.3.1
ARG CUDA=11.3
ARG CUDNN_VERSION=8

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}

# Need to be re-declared after the FROM statement for re-use in the build below
ARG CUDA_VERSION
ARG CUDA
ARG CONDA_ENV_NAME=pytorch-cuda-${CUDA}
ARG PYTORCH_VERSION=1.12.0
ARG PYTHON_VERSION=3.7

ENV DEBIAN_FRONTEND=noninteractive

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates ccache curl build-essential cmake ninja-build lsb-release gnupg2 sudo \
  python3-pip zsh git wget pkg-config software-properties-common ssh openssh-server unzip vim \
  libopencv-dev \
  libopenblas-dev
  
# For reducing the image size   
RUN rm -rf /var/lib/apt/lists/*

# CUDA profiling and library setup
ENV LD_LIBRARY_PATH /usr/local/cuda-${CUDA}/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
  echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && \
  ldconfig

SHELL ["/bin/bash", "-c"]

# Miniconda setup with root permissions
# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
RUN curl -o /tmp/miniconda.sh -sSL http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  chmod +x /tmp/miniconda.sh && \
  bash /tmp/miniconda.sh -bfp /usr/local && \
  rm /tmp/miniconda.sh && \
  conda update -y conda

# User creation: Pass the arguments at the build time
ARG UID=
ARG USER_NAME=
RUN adduser $USER_NAME -u $UID --quiet --gecos "" --disabled-password && \
  echo "$USER_NAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME && \
  chmod 0440 /etc/sudoers.d/$USER_NAME

# SSH Configuration
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
  echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
  echo "UsePAM no" >> /etc/ssh/sshd_config

# User setup
USER $USER_NAME
SHELL ["/bin/bash", "-c"]

# Conda environment setup
RUN conda create -n ${CONDA_ENV_NAME} python=${PYTHON_VERSION}
ENV PATH /usr/local/envs/$CONDA_ENV_NAME/bin:$PATH
RUN echo "source activate ${CONDA_ENV_NAME}" >> ~/.bashrc

# JupyterLab Installation
RUN source activate ${CONDA_ENV_NAME} && \
    conda install -c conda-forge jupyterlab
    # jupyter server extension enable --py jupyterlab --sys-prefix

# PyTorch Installation
# RUN source activate ${CONDA_ENV_NAME} && \
    # conda install pytorch=${PYTORCH_VERSION} torchvision torchaudio cudatoolkit=${CUDA} -c pytorch

# Install Oh My Zsh and zsh plugins in one RUN command
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    # Zsh setup
    echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> ~/.zshrc && \
    echo "source ~/.oh-my-zsh/oh-my-zsh.sh" >> ~/.zshrc && \
    # Set the prompt to indicate the docker environment
    echo 'export PS1="[Docker] $PS1"' >> ~/.zshrc

SHELL ["/usr/bin/zsh", "-c"]