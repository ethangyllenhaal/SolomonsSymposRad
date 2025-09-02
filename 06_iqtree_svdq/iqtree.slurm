#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00
#SBATCH --job-name=solsym_iqtree
#SBATCH --output=_iqtree_out_%j
#SBATCH --error=_iqtree_error_%j
#SBATCH --partition=normal
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

#cd $SLURM_SUBMIT_DIR
#module load miniconda3
#source activate iqtree-env

# base IQtree runs
iqtree -s full_rad_75.phylip -m MFP -B 1000 -T 8
iqtree -s sympos_uce_raxml_90.phylip -m MFP -B 1000 -T 8

# concordance factor for RAD data
iqtree -t full_rad_75.phylip.treefile \
       --scf 5000 \
       -s full_rad_75.phylip \
       --prefix solsym_cf_full_75 -T 8
