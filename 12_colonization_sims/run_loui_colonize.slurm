#!/bin/bash

#SBATCH --ntasks=90
#SBATCH --time=48:00:00
#SBATCH --job-name=solo_colo
#SBATCH --output=_colo_out_%j
#SBATCH --error=_colo_error_%j
#SBATCH --partition=general
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

module load miniconda3
module load parallel
source activate slim4-env
source $(which env_parallel.bash)

cd $SLURM_SUBMIT_DIR

scontrol show hostname > ./node_list_${SLURM_JOB_ID}
export LANG=C

#env_parallel -j 8 --sshloginfile ./node_list_${SLURM_JOB_ID} \
echo    'echo -e "newgeorgia\tmalaita\tmakira\tbukida" > \
          $SLURM_SUBMIT_DIR/output_loui/coltimes_d{1}.txt
      echo -e "newgeorgia\tmalaita\tmakira\tbukida" > \
          $SLURM_SUBMIT_DIR/output_loui/source_d{1}.txt
      echo -e "newgeorgia\tmalaita\tmakira\tbukida\tnewgeorgia\tmalaita\tmakira\tbukida" > \
          $SLURM_SUBMIT_DIR/output_loui/sumstats_d{1}.txt' \
     ::: 200 400 600 800 1000 1200 1600

env_parallel -j 8 --delay 1 --resume --joblog ./loui.log --sshloginfile ./node_list_${SLURM_JOB_ID} \
    'slim -d mean_dispersal={1} -d replicate={2} \
          $SLURM_SUBMIT_DIR/solsym_nonWF_carc_loui_v2.slim' \
    ::: 200 400 600 800 1000 1200 1600 ::: {1..500}
