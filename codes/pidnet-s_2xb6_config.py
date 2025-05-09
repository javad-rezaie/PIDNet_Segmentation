_base_ = ['./pidnet-s_2xb6-model.py', 
]
def get_num_classes():
    from mmseg.datasets import ADE20KDataset, CityscapesDataset, COCOStuffDataset, LoveDADataset
    # return len(ADE20KDataset.METAINFO["classes"])
    # return len(CityscapesDataset.METAINFO["classes"])
    # return len(COCOStuffDataset.METAINFO["classes"])
    return len(LoveDADataset.METAINFO["classes"])

num_classes = get_num_classes()

model = dict(
    decode_head=dict(
        num_classes=num_classes
    )
)

# configure default hooks
default_hooks = dict(

    # save checkpoint per epoch.
    checkpoint=dict(type='CheckpointHook', max_keep_ckpts=1),
)


train_pipeline = [
    dict(type='LoadImageFromFile'),
    dict(type='LoadAnnotations'),
    dict(
        type='RandomResize',
        scale=(2048, 512),
        ratio_range=(0.5, 2.0),
        keep_ratio=True),
    dict(type='RandomCrop', crop_size=_base_.crop_size, cat_max_ratio=0.75),
    dict(type='RandomFlip', prob=0.5),
    dict(type='PhotoMetricDistortion'),
    dict(type='GenerateEdge', edge_width=4),
    dict(type='PackSegInputs')
]
train_dataloader = dict(dataset=dict(pipeline=train_pipeline))
work_dir = "/out"