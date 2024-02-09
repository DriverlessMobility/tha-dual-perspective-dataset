# THA Dual-Perspective Dataset
This repository provides the Dual-Perspective Dataset and code used in the paper "Transfer-Learning of a LiDAR Detection Algorithm Pre-Trained on Autonomous Driving Data for Roadside Infrastructure Application".

Dataset Download: [here](https://l.linklyhq.com/l/1uGNk)

## Environment Setup
First build the docker image:
```
docker build --tag centerpoint4feature .
```

Next start a container and make sure to mount the datasets and the repository:

```
docker run --gpus all\
        -it \
        --network host \
        --name dual-perspective \
        --volume /PATH/TO/WAYMO_DATASET_ROOT:/data/waymo-open \
        --volume /PATH/TO/THA_DUALPERSPECTIVE_DATASET_ROOT:/data/THA_DualPerspective_Dataset \
        --volume /PATH/TO/REPOSITORY_ROOT:/workspace \
        centerpoint4feature:latest
```

## Train
To train CenterPoint with the waymo-open dataset with four features use these commands:

``` 
python tools/create_data.py waymo_data_prep --root_path=/data/waymo-open --split train --nsweeps=1
python tools/train.py /workspace/configs/waymo_centerpoint_pp_two_pfn_stride1_3x_waymo.py --work_dir /workspace/work_dir/WaymoTraining
```

For Finetuning these weights on the infrastructure data use:

```
python tools/create_data.py waymo_data_prep --root_path="/data/THA_DualPerspective_Dataset/ITS-S" --split train --nsweeps=1 --randomlySample=False
python tools/train.py /workspace/configs/waymo_centerpoint_pp_two_pfn_stride1_3x_its.py --work_dir /workspace/work_dir/its_finetuning --resume_from /workspace/work_dir/WaymoTraining/latest.pth
```

## Test
To perform inference and compute the mAP and mAPH based on the AV and the infrastructure subset as mentioned in the paper use:
```
/workspace/InferenceAndComputeMetrics.sh
```

## Contact
Any questions or suggestions are welcome! \
Daniel.Lengerer@hs-augsburg.de

## License
The dataset itself is released under the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (CC BY-NC-ND 4.0)](https://creativecommons.org/licenses/by-nc-nd/4.0/). By downloading the dataset you agree to the terms of this license.

The scripts found in the repository are released under MIT license as found in the license file.

## Citation
    @inproceedings{lengerer2023lidar,
        title={Transfer-Learning of a LiDAR Detection Algorithm Pre-Trained on Autonomous Driving Data for Roadside Infrastructure Application},
        author={Lengerer, Daniel and Pechinger, Mathias and Markgraf, Carsten},
        publisher={IEEE},
        booktitle={2023 IEEE Intelligent Transportation Systems Conference (ITSC)},
        year={2023}
    }
