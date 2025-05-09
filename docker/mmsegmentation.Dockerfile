# syntax=docker/dockerfile:1

#---------------------HOMAI------------------------#
# Created on Sun May 3 2025
#
# Copyright (c) 2025 The Home Made AI (HOMAI)
# Author: Javad Rezaie
# License: Apache License 2.0
#---------------------HOMAI------------------------#


ARG PYTORCH="2.1.2"
ARG CUDA="11.8"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ARG DEBIAN_FRONTEND=noninteractive
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1"

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 curl wget\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MMEngine, MMCV, MMSegmentation
RUN pip install openmim && \
    mim install mmengine
# Install JupyterLab if you are interested to run experiments on the docker and seaborn to plot logs
RUN mim install jupyterlab ipykernel seaborn ftfy regex 
RUN git clone https://github.com/open-mmlab/mmsegmentation.git &&\
    cd mmsegmentation && git checkout v1.2.2 && pip install albumentations==1.3.1 &&\
    mim install -v -e .
