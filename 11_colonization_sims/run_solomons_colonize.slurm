#!/bin/bash

#SBATCH --ntasks=80
#SBATCH --time=48:00:00
#SBATCH --job-name=solo_colo
#SBATCH --output=colo_out_%j
#SBATCH --error=colo_error_%j
#SBATCH --partition=normal
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

# By: Ethan Gyllenhaal
# Last updated: 7 November 2022
# Slurm batch script for running simulations in parallel
# First runs something to set up input files
# Then runs colonization simulations over: 
## 6 dispersal values
## 2 factors of map type and starting point
## 500 replicates

# load modules, activate environment
module load miniconda3
module load parallel
source activate slim-env
source $(which env_parallel.bash)

# change to working directory, make node list
cd $SLURM_SUBMIT_DIR
scontrol show hostname > ./node_list_${SLURM_JOB_ID}

# set up output files (comment out if tou need to resume second job)
env_parallel -j 8 --sshloginfile ./node_list_${SLURM_JOB_ID} \
    'echo -e "bukida\tnewgeorgia\tmalaita\tmakira" > \
          $SLURM_SUBMIT_DIR/output/coltimes_{2}_{3}_d{1}.txt' \
     ::: 50 100 200 300 400 800 ::: lgm modern ::: newgeorgia bukida

# run simulations, setting slim values to combination of parameters/replicate number
env_parallel -j 8 --delay 1 --joblog ./multiWF.log --sshloginfile ./node_list_${SLURM_JOB_ID} \
    'slim -d mean_dispersal={1} -d "map={2}" -d "start={3}" -d replicate={4} \
          $SLURM_SUBMIT_DIR/solsym_nonWF_carc_static.slim' \
    ::: 50 100 200 300 400 800 ::: 0 1 ::: 0 1 ::: {1..500}
