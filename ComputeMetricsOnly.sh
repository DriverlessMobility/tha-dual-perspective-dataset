#!/bin/bash

echo "AV-Dataset trained Baseline Weights Inference on Dual-Perspective AV Subset"
/CenterPoint/compute_detection_metrics_main /workspace/work_dir/AV_Test/detection_pred.bin /workspace/work_dir/AV_Test/gt_preds.bin

echo ""
echo "AV-Dataset trained Baseline Weights Inference on Dual-Perspective Infrastructure Subset"
/CenterPoint/compute_detection_metrics_main /workspace/work_dir/ITS_Test/detection_pred.bin /workspace/work_dir/ITS_Test/gt_preds.bin

echo ""
echo "AV-Dataset trained Baseline Weights finetuned with Infrastructure Training Subset Inference on Dual-Perspective Infrastructure Subset"
/CenterPoint/compute_detection_metrics_main /workspace/work_dir/ITS_finetuned_Test/detection_pred.bin /workspace/work_dir/ITS_finetuned_Test/gt_preds.bin