#!/bin/bash

echo -e "\033[1;32mInstalling Miniconda3...\033[0m\n"

mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh

echo "source miniconda3/bin/activate" >> ~/.bashrc && source ~/.bashrc
echo "source miniconda3/bin/activate" >> ~/.zshrc && source ~/.zshrc
conda init --all && conda config --set auto_activate_base false

echo -e "\033[1;32mMiniconda3 has been installed.\033[0m\n"
