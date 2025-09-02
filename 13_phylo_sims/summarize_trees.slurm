#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --job-name=arch_msp
#SBATCH --output=_trees_out_%j
#SBATCH --error=_trees_error_%j
#SBATCH --partition=debug
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

# Load miniconda and parallel modules
module load miniconda3

# Activate the environment and load env_parallel
source activate ete3-env

# Set a directory path to working directory, then make node list for parallelizing across nodes
dir=$SLURM_SUBMIT_DIR
export LANG=C

python summarize_trees_bs.py -o summarize_buk.txt -i 'output_big/tree/archsim*buk*treefile'
python summarize_trees_bs.py -o summarize_mak.txt -i 'output/tree/archsim*mak*treefile'

