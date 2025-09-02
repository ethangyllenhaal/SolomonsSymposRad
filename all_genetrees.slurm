#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=6:00:00
#SBATCH --job-name=genetrees
#SBATCH --output=_gt_out_%j
#SBATCH --error=_gt_error_%j
#SBATCH --partition=normal
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=egyllenhaal@unm.edu

cd $SLURM_SUBMIT_DIR
src=$SLURM_SUBMIT_DIR

# load parallel and miniconda
module load parallel
module load miniconda3
# make node list
scontrol show hostname > $src/node_list_${SLURM_JOB_ID}
# load env parallel
source $(which env_parallel.bash)

# stacks environment
source activate stacks-env

# re-run gstacks for these samples
gstacks -I $src/bam_files/ -M $src/popmaps/popmap_genetrees -O $src/stacks_out/genetrees_all/ -t 8
# populations to get locus fastas
populations -P $src/stacks_out/genetrees_all -M $src/popmaps/popmap_genetrees -O $src/populations/genetrees_all --vcf -R 1 --fasta-samples -t 8

# has phykit and iqtree
source activate phykit-env

# Only pull first allele
grep '>' populations/genetrees_all/populations.samples.fa | grep 'Sample_1.*Allele_0' | cut -f2 -d '_' \
    > genetrees/locus_list_all

# run gene trees, originally run stepwise, -gt N-1 gives you ones with at least N PIS
cat genetrees/locus_list_all | env_parallel -j 8 --sshloginfile $src/node_list_${SLURM_JOB_ID} \
    'grep -A1 Locus_{}_.*Allele_0 $src/populations/genetrees_all/populations.samples.fa | \
          sed -z "s/--\n//g" |
          sed "s/CLocus_{}_Sample_._Locus_{}_Allele_0 \[//g" |
          sed "s/; .*\]//g" > $src/genetrees/all/locus_{}.fasta
     if [ $(phykit pis $src/genetrees/all/locus_{}.fasta | cut -f 1) -gt 0 ]
        then iqtree -s $src/genetrees/all/locus_{}.fasta -m GTR+I+G -T 1; echo {} >> $src/genetrees/all_pis1.list
     fi
     if [ $(phykit pis $src/genetrees/all_PIS2/locus_{}.fasta | cut -f 1) -gt 1 ]
        then iqtree -s $src/genetrees/all_PIS2/locus_{}.fasta -m GTR+I+G -T 1; echo {} >> $src/genetrees/all_pis2.list
     fi
     if [ $(phykit pis $src/genetrees/all_PIS3/locus_{}.fasta | cut -f 1) -gt 2 ]
        then iqtree -s $src/genetrees/all_PIS3/locus_{}.fasta -m GTR+I+G -T 1; echo {} >> $src/genetrees/all_pis3.list
     fi'
