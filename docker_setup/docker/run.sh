docker run -it --name test \
    --gpus all \
    -p 8888:8888 \
    -v $PWD:/workspace \
    -w /workspace \
    Ikhyeon/torch-cuda:11.3.1-devel-ubuntu20.04 \
    /bin/zsh