#!/bin/bash

#SBATCH --ntasks=10
#SBATCH --cpus-per-task=32
#SBATCH --time=48:00:00
#SBATCH --job-name=arch_msp
#SBATCH --output=_trees_out_%j
#SBATCH --error=_trees_error_%j
#SBATCH --partition=condo
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

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

#rm $dir/output/sim/*stats.txt

#env_parallel -j 8 --delay 1 --joblog $dir/solo_msp_log --sshloginfile $dir/node_list_${SLURM_JOB_ID} \
echo             'python $dir/new_solo_phylo_msp.py -d {1} -n {2} -t {3} -i {4} -f {5} -r {6} \
                     -o $dir/output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}
              sh $dir/variant_fasta.sh $dir/output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}.fasta \
                 $dir/output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}_var.fasta
              rm $dir/output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}.fasta' \
              ::: 0.0001 10 15 20 30 40 50 60 80 100 ::: 50000 100000 200000 ::: 200000 400000 800000 1600000 3200000 ::: 25000 50000 100000 200000 400000 ::: mak buk ::: {1..50}

# full
#::: 0.0001 10 15 20 30 40 50 60 80 100 ::: 50000 100000 200000 ::: 200000 400000 800000 1600000 3200000 ::: 25000 50000 100000 200000 400000 ::: mak buk ::: {1..50}

env_parallel -j 8 --delay 1 --resume --joblog $dir/solo_iq_log --sshloginfile $dir/node_list_${SLURM_JOB_ID} \
	     'iqtree -s $dir/output/sim/archsim_d{1}_n{2}_t{3}_i{4}_{5}_r{6}_var.fasta \
                       --prefix $dir/output/tree/archsim_m{1}_n{2}_e{3}_i{4}_{5}_r{6} \
                       -m JC -B 1000 -T 4 --redo' \
	      ::: 0.0001 10 15 20 30 40 50 60 80 100 ::: 50000 100000 200000 ::: 200000 400000 800000 1600000 3200000 ::: 25000 50000 100000 200000 400000 ::: mak buk ::: {1..50}

