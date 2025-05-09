#---------------------HOMAI------------------------#
# Created on Sun May 3 2025
#
# Copyright (c) 2025 The Home Made AI (HOMAI)
# Author: Javad Rezaie
# License: Apache License 2.0
#---------------------HOMAI------------------------#

################## Environmental Variables
#Data Structure on my local computer is as follows:
#/mnt/SSD2/LoveDA/
#├── img_dir/
#└── ann_dir/

#It will be mapped to container, and it seems like:
#/data/
#├── img_dir/
#└── ann_dir/

DATA_ROOT=/mnt/SSD2/LoveDA

TRAIN_IMAGE_PATH=img_dir/train/
VAL_IMAGE_PATH=img_dir/val/
TEST_IMAGE_PATH=img_dir/test/
TRAIN_SEG_MAP_PATH=ann_dir/train/
VAL_SEG_MAP_PATH=ann_dir/val/
TEST_SEG_MAP_PATH=ann_dir/test/

WORK_DIR=$PWD/out/
CONFIG="/configs/pidnet-s_2xb6_config.py"
BATCH_SIZE=32

#############################################################################

GPUS=2


docker run -it --rm \
    --gpus all \
    -e DATA_ROOT=$DATA_ROOT \
    -e TRAIN_IMAGE_PATH=$TRAIN_IMAGE_PATH \
    -e TEST_IMAGE_PATH=$TEST_IMAGE_PATH \
    -e VAL_IMAGE_PATH=$VAL_IMAGE_PATH \
    -e TRAIN_SEG_MAP_PATH=$TRAIN_SEG_MAP_PATH \
    -e TEST_SEG_MAP_PATH=$TEST_SEG_MAP_PATH \
    -e VAL_SEG_MAP_PATH=$VAL_SEG_MAP_PATH \
    -e BATCH_SIZE=$BATCH_SIZE \
    --mount type=bind,source=$PWD/codes/,target=/configs \
    --mount type=bind,source=$DATA_ROOT,target=/data \
    --mount type=bind,source=$WORK_DIR,target=/out \
    --shm-size 8g \
    mmsegmentation:latest \
    torchrun --nnodes 1 --nproc_per_node=$GPUS  /configs/main_train_mmengine.py $CONFIG 