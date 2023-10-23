#!/bin/bash
echo "Generating lots of data"

mkdir /workspace/work_dir/AV_Test/ /workspace/work_dir/ITS_Test/ /workspace/work_dir/ITS_finetuned_Test/
# first generate some data
python tools/create_data.py waymo_data_prep --root_path=/data/THA_DualPerspective_Dataset/AV --split val --nsweeps=1
python tools/create_data.py waymo_data_prep --root_path=/data/THA_DualPerspective_Dataset/ITS-S --split val --nsweeps=1

# generate gt files for metrics computation tool
python det3d/datasets/waymo/waymo_common.py --info_path /data/THA_DualPerspective_Dataset/AV/infos_val_01sweeps_filter_zero_gt.pkl --result_path /workspace/work_dir/AV_Test/ --gt
python det3d/datasets/waymo/waymo_common.py --info_path /data/THA_DualPerspective_Dataset/ITS-S/infos_val_01sweeps_filter_zero_gt.pkl --result_path /workspace/work_dir/ITS_Test/ --gt
python det3d/datasets/waymo/waymo_common.py --info_path /data/THA_DualPerspective_Dataset/ITS-S/infos_val_01sweeps_filter_zero_gt.pkl --result_path /workspace/work_dir/ITS_finetuned_Test/ --gt

echo "Executing Inference"

# Inference for the three cases
python ./tools/dist_test.py /workspace/configs/waymo_centerpoint_pp_two_pfn_stride1_3x_av.py --checkpoint /workspace/work_dir/WaymoTraining/latest.pth --work_dir /workspace/work_dir/AV_Test
python ./tools/dist_test.py /workspace/configs/waymo_centerpoint_pp_two_pfn_stride1_3x_its.py --checkpoint /workspace/work_dir/WaymoTraining/latest.pth --work_dir /workspace/work_dir/ITS_Test
python ./tools/dist_test.py /workspace/configs/waymo_centerpoint_pp_two_pfn_stride1_3x_its.py --checkpoint /workspace/work_dir/its_finetuning/latest.pth --work_dir /workspace/work_dir/ITS_finetuned_Test

bash /workspace/ComputeMetricsOnly.sh
