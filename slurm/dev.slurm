#!/bin/bash
#SBATCH --job-name=action-recognition-inference
#SBATCH --account=aisc
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=slack:daniel.kiss
#SBATCH --container-image=kdaniel21/action-benchmark:latest
#SBATCH --container-name=action-recognition-inference
#SBATCH --container-mount-home
#SBATCH --container-mounts=/sc/projects/sci-aisc/gorilla:/sc/projects/sci-aisc/gorilla
#SBATCH --container-writable
#SBATCH --partition=aisc-batch
#SBATCH --cpus-per-task=4
#SBATCH --mem=32gb
#SBATCH --gpus=h100:1
#SBATCH --exclude=ga03
#SBATCH --time=01:00:00
#SBATCH --output=logs/%x_%j.log

/sc/home/daniel.kiss/tunnel.sh