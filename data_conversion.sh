#---------------------HOMAI------------------------#
# Created on Sun May 3 2025
#
# Copyright (c) 2025 The Home Made AI (HOMAI)
# Author: Javad Rezaie
# License: Apache License 2.0
#---------------------HOMAI------------------------#

DATA_DIR="/mnt/SSD2/" # In the container, it is acceable as /data
#Data Structure on my local computer is as follows:
#/mnt/SSD2/LoveDA/
#├── img_dir/
#└── ann_dir/

#It will be mapped to container, and it seems like:
#/data/
#├── img_dir/
#└── ann_dir/



docker run -it --rm \
    --gpus all \
    --mount type=bind,source=$DATA_DIR,target=/data \
    --shm-size 8g \
    mmsegmentation:latest \
    /bin/bash -c "mkdir -p /data/LoveDA && cd /data/LoveDA &&\
    wget https://zenodo.org/record/5706578/files/Train.zip &&\
    wget https://zenodo.org/record/5706578/files/Val.zip &&\
    wget https://zenodo.org/record/5706578/files/Test.zip &&\
    python /workspace/mmsegmentation/tools/dataset_converters/loveda.py /data/LoveDA/ -o /data/LoveDA/"