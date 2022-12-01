#!/bin/bash

#SBATCH --ntasks=5
#SBATCH --cpus-per-task=8
#SBATCH --time=48:00:00
#SBATCH --job-name=arch_msp
#SBATCH --output=trees_out_%j
#SBATCH --error=trees_error_%j
#SBATCH --partition=normal
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

# By: Ethan Gyllenhaal
# Last updated: 7 November 2022
# Slurm batch script for running simulations in parallel
# Runs colonization simulations over: 
## 11 dispersal values (0.0001 is 0)
## 30 replicates
# Then processes the output to remove invariant sites
# And finally runs RAxML


# Load miniconda and parallel modules
module load miniconda3
module load parallel

# Activate the environment and load env_parallel
source activate msptree-env
source $(which env_parallel.bash)

# Set a directory path to working directory, then make node list for parallelizing across nodes
dir=$SLURM_SUBMIT_DIR
scontrol show hostname > $dir/node_list_${SLURM_JOB_ID}
export LANG=C

# Runs simulations and fasta processing...
env_parallel -j 4 --delay 1 --sshloginfile $dir/node_list_${SLURM_JOB_ID} \
	     'python $dir/solo_phylo_msp.py -d {1} -r {2} \
	     	     -o $dir/output/alignments/archsim_d{1}_r{2}_all.fasta
              sh $dir/variant_fasta.sh $dir/output/alignments/archsim_d{1}_r{2}_all.fasta \
                 $dir/output/alignments/archsim_d{1}_r{2}.fasta
              rm $dir/output/alignments/archsim_d{1}_r{2}_all.fasta' \
		     ::: 0.0001 10 15 20 25 30 35 40 60 80 120 ::: {1..30}

# Then runs RAxML on that output
env_parallel -j 4 --delay 1 --sshloginfile $dir/node_list_${SLURM_JOB_ID} \
	     'raxml-ng --all --prefix $dir/output/trees/raxml_d{1}_r{2} \
                       --msa $dir/output/alignments/archsim_d{1}_r{2}.fasta \
		       --outgroup Outgroup1,Outgroup2,Outgroup3,Outgroup4 \
	     	       --model JC --threads 8 --bs-trees 100' \
	     ::: 0.0001 10 15 20 25 30 35 40 60 80 120 ::: {1..30}
