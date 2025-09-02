README by: Ethan Gyllenhaal
Last updated: 20 May 2025

Repository for scripts and input files used in a study investigating gene flow and its impacts on phylogeography in a radiation of Symposiachrus monarch flycatchers in the Solomon islands. Everything is in subfolders within a zipped file. If you use something here, please cite us, or contact EFG on who is best to cite (and remind him if he forgets to update the citation):

This README describes the scripts and data files used for the afforementioned project. The data were collected using Illumina sequencing for RAD-seq libraries, largely following the Stacks reference-based pipeline. Scripts and input data file are in the same folder for a given analysis.

## Useage

The majority of the data included here is output from a Stacks bioinformatics pipeline, which was run as a Torque script on a high performancce computing center. Individual VCFs were then processed with command line tools (e.g., vcftools) or R scripts for preparing figures, tables, etc for the paper. Data file formats (e.g. vcf, phylip) are standard except when noted. Additionally, there are two sets of simulation scripts and output (SLiM and msprime). Access reccomendations per data type are below. All data types except .xlsx and compressed files can be viewed in any plain text editor, but certain files are large enough that may not be advisable depending on the editor.

### Stacks pipeline (01_stacks)

run_stacks_pipeline.pbs - Torque submission script used to run the pipeline. It was very quick, using only a single 8-core node for <10 hours. Made to run on UNM's Center for Advanced Research Computing's Wheeler cluster.

popmaps directory - Directory of population maps used to make subset input files. Individual files are below, with the first column denoting sample names and second population assignment:
*popmap_NG - New Georgia Group samples
*popmap_bukida - Bukida Group samples
*popmap_full - All samples
*popmap_full_indiv - All samples, but with a dummy population used to output per-individual phylip files
*popmap_solo - All Solomon Island samples
*snapp_even - SNAPP input with three samples per island group and two samples from an outgroup
*snapp_five_island - SNAPP input with up to five islands per island group (two per island if group have more than one) and two samples from an outgroup
*snapp_two_island - SNAPP input with up to two islands per island group (two per island if group have more than one) and two samples from an outgroup

### Adegenet (02_adegenet)

SoloSympos_PCA.R - R script for the 3 PCAs in the paper (resulting in 4 figures), with the first one walking through the process in detail. The full and Bukida PCAs are in Figure 2. The New Georgia PCAs are in Figure S1.

### Admixture (03_admixture)

solsym_admixture_plot.R - R script for plotting Admixture results. Output used in Figure 2.

run_admixture_NG.sh - Shell script for running Admixture. Assumes a conda environment with Plink and Admixture is loaded (or similar ways of making "plink" and "admixture" call their respective programs).

### Confirming intergrade (04_confirm_intergrade)

keep_interspecific - Sample list of individuals to keep for fixed SNP analysis (only one is used, rest are there to confirm we do indeed have fixed SNPs)

kolo_etc_samples - Sample list of Kolombangara and connected islands.

rano_vella_samples - Sample list of Vella Lavella and Ranongga.

run_interspecific_het.sh - Main script, first uses VCFtools and unix commands to find fixed SNPs (between the combined Kolombangara etc and Vella/Ranongga populations), then limits input VCF to those SNPs, then does some unix math so calculate proportion of heterozygotes for the focal individual at those sites. Comparable to what the program introgression calculates.

### Pairwise Fst (05_pairwise_Fst)

pairwise_Fst_vcftools.sh - Shell script used for calculating pairwise Fst between all Solomons population using VCFtools. Output used in Table 1.

pops directory - Files used to specify populations.

### IQTree and SVDQuartet (06_iqtree_svdq)

NOTE: SVDQuartets analyses were run with the PAUP GUI. Output in Figure 3 and Figure S2.

iqtree.slurm - SLURM batch script for running IQTree for inference on RAD and UCE data, as well as site concordance factor calculation for RAD data.

full_rad_75.phylip.treefile - Output from IQtree, without concordance factors.

solsym_cf_full_75.cf.tree - Phylogeny for RAD dataset with concordance factors on nodes.

solsym_cf_full_75.cf.stat - Full concordance factor data for RAD dataset.

solomons_triv_SVDQ_75.tre - SVDQuartets phylogeny for ingroup and S. trvirgatus. Tips are grouped together.

### SNAPP (07_SNAPP)

NOTE: Some steps were run with the Beauti GUI. Output in Figure 4.

snapp_input_maker.sh - Driver script for converting a VCF to diploid SNAPP input (i.e. Nexus input for processing in Beauti). Converts from VCF to haploid SNAPP using https://github.com/BEAST2-Dev/SNAPP/tree/master/script, then to diploid SNAPP using a custom python script (SNAPP_haploid_to_diploid.py), and finally adding lines for a new nexus file using sed commands. Now takes command line arguments (relative to original version).

generate_snapp_input.sh - Simple script with commands for each SNAPP input file.

SNAPP_haploid_to_diploid.py - Script for converting a tab-delimited set of haploid nexus SNP data to diploid data. Takes and outputs "middle" lines, header and footer done by "snapp_input_maker.sh". Note that it's "dumb" and needs the input to be named "snapp_dip.txt" and outputs "snapp_out.txt".

treeanno_\*.tre - TreeAnnotator summary trees.

### UCEs Phylogenies (08_UCEs) 

NOTE: SVDQuartets analyses were run with the PAUP GUI. Output in Figure 3. IQTREE script is in section 06.

run_phyluce_solo_triv.sh - Shell script for running PHYLUCE pipeline. Starts with cleaned reads and outputs Nexus and Phyllip files.

solsym_uce.conf - Taxon set .conf file. Used in several phyluce calls.

solsym_spades.conf - Spades .conf file, note paths are changed to generic ones up until clean reads folder. Used in phyluce_assembly_assemblo_spades.

sympos_uce_SVDQ_90.tre - Tree produced by SVDQ, combining samples by population.

sympos_uce_raxml.tre - Tree produced by RAxML, combining samples by population.

### DSuite (09_DSuite)

NOTE: The topologies and popmaps have 6 consistent name corresponding to subfigures in Figure S3. B = main, C = noMal, D = conservative, E = conservative_noMal, F = malbar G = malbar_conservative.

run_D.sh - Shell script used for running Dsuite. The first one is used for the main ABBA/BABA results (Figure 5). The first and the rest are used for fbranch (Figure S3).

fbranch_topologies/\* - Topologies used for fbranch, outlined below:
*topo_main.nwk - The main topology.
*topo_noMal.nwk - Malaita removed.
*topo_conservative.nwk - Certain populations removed to avoid uncertainty within island groups.
*topo_conservative_noMal.nwk - As above, but also with Malaita removed.
*topo_malbar.nwk - New Georgia samples removed.
*topo_malbar_conservative.nwk - New Georgia samples and one uncertain Bukida sample removed.

pop_maps/\* - Population maps used for the runs. All but two downsampled ones match the above topologies. These downsampled maps match the main topology:
*map_downsample3 - Population map with a maximum of 3 samples per population.
*map_downsample2 - Population map with a maximum of 2 samples per population.

### Genetrees (10_genetrees)

all_genetrees.slurm - Slurm batch script for making locus-specific fastas and running gene trees with given numbers of parsimony informative sites.

check_monophyly_all.py - Python script for outputting proportion and branch length stats for gene trees.

popmap_genetrees - Population map for gene tree samples (one per island group).

### Photos of intergrade (11_photos)

All of these are photos of the intergrade (center), Ranongga samples (left two), and Kolombangara samples (right two). They show the view over the underparts (Belly_View_Full.jpeg), sides (Side_View_Full.jpeg), and the main one used in Figure 2 (Main_hybrid_comp.png). 

### Colonization simulations (12_colonization_sims)

solomons_colonize_nonWF.slim - Slim script used to run colonization simulations.

run_solomons_colonize.slurm - Slurm script used to run simulations in parallel. Requires a conda environment with SLiM.

drive_summarize.sh - Script used to modify output then run python script.

summarize_output.py - Script used to summarize the output from slim.

### Phylogenetic simulations (13_phylo_sims)

solomons_phylo_msp.py - Script for running msprime simulations, made to be run in parallel.

run_solomons_msp.slurm - Slurm batch script for running replicates of msprime followed by RAxML. Requires a conda environment with msprime and RAxML (plus other python packages).

make_variant_fasta.sh - Script for removing invariant sites to keep alignment files smaller for storage purposes.

output_trees.zip - Zipped directory of trees output by RAxML. The "d" corresponds to dispersal distance (0.0001 acts as 0) and r is the replicate number.


### Additional summary simulation files (14_bonus_sim_stats)

plot_sumstats.R - Script for plotting a lot of data exploration plots not used in the paper.

source_d\* - Source population data from SLiM simulations for a range of dispersal values. From left to right, columns are the source population values for the New Georgia Group, Malaita, Makira, and the Bukida Group.

sumstat_d\* - Summary stat (pi and private alleles) data for SLiM simulations for a range of dispersal values. From left to right, the first four columns are for pi and second four for private allele count, each in the order of: New Georgia Group, Malaita, Makira, Bukida Group.

sumstat_combined - Msprime output for all simulations, first with parameters then with population-specific summary stats. The first 6 columns are: dispersal distance, total Ne, post-split divergence time, split interval, simulation start point, and replicate number. Next four are pi (for Bukida, New Georgia, Malaita, Makira) and then number of private alleles (in the same order).
