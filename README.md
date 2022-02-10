# SolomonsSymposRad
Repository for scripts used in a project assessing the prevalence of gene flow in a young geographic radiation of monarch flycatchers in the Solomon Islands. README for everything is below, but information for input files not included are there as well (denoted by $$$ at the start of the name). Those can be found a Dryad at a currently privated link.

Last updated: 9 February 2022

Repository for scripts and input files used in a study investigating gene flow and its impacts on phylogeography in a radiation of Symposiachrus monarch flycatchers in the Solomon islands. If you use something here, please cite us, or contact EFG on who is best to cite (and remind him if he forgets to update the 
citation):

This README describes the scripts and data files used for the afforementioned project. The data were collected using Illumina sequencing for RAD-seq libraries, largely following the Stacks reference-based pipeline. Scripts and input data file are in the same folder for a given analysis.

_______________________________
------- Stacks pipeline -------
------- (01_stacks.zip) -------
_______________________________

run_stacks_pipeline.pbs - Torque submission script used to run the pipeline. It was very quick, using only a single 8-core node for <10 hours. Made to run on UNM's Center for Advanced Research Computing's Wheeler cluster.

popmaps directory - Directory of population maps used to make subset input files.

_______________________________
------ PCAs with Adegenet -----
------ (02_adegenet.zip) ------
_______________________________

SoloSympos_PCA.R - R script for the 3 PCAs in the paper (resulting in 4 figures), with the first one walking through the process in detail. The Bukida PCA is in Figure 2. The other PCAs are in Figure S1.

$$$solsym_\*_75.vcf - 75% complete VCF files for subsets of the data (all Solomons birds, all Bukida birds, and all New Georgia birds, respectively).

_______________________________
---------- Admixture ----------
----- (03_admixture.zip) ------
_______________________________

solsym_admixture_plot.R - R script for plotting Admixture results. Output used in Figure 3.

run_admixture_NG.sh - Shell script for running Admixture. Assumes a conda environment with Plink and Admixture is loaded (or similar ways of making "plink" and "admixture" call their respective programs).

$$$solsym_NG_75.* - Plink input files from Stacks, with 75% completeness for New Georgia Samples.

$$$solsym_NG_75_12.* - Plink files from prior line converted to 12 format for use in Admixture.
_______________________________
--------- Pairwise Fst --------
---- (04_pairwise_Fst.zip) ----
_______________________________

pairwise_Fst_vcftools.sh - Shell script used for calculating pairwise Fst between all Solomons population using VCFtools. Output used in Table 1.

pops directory - Files used to specify populations.

$$$solsym_solomons_75.vcf - 75% complete VCF file for Solomons subset of data.
_______________________________
----- RAxML and SVDQuartet ----
----- (05_raxml_svdq.zip) -----
_______________________________

NOTE: These analyses were run with the PAUP GUI (SVDQ) and Cipres (RAxML). Output in Figure 4 and Figure S2.

full_raxml_rad_75.tre - RAxML phylogeny for all samples, individually.

$$$full_rad_75.phylip - Input for RAxML, generated with Stacks with slight manual modifications.

solomons_triv_SVDQ_75.tre - SVDQuartets phylogeny for ingroup and S. trvirgatus. Tips are grouped together.

$$$solomons_triv_SVDQ_75.nex - SVDQuartets input modified from RAxML phylip without a script. Removed all outgroups other than trvirgatus.

_______________________________
------------ SNAPP ------------
------- (06_SNAPP.zip) --------
_______________________________

NOTE: Some steps were run with the Beauti GUI. Output in Figure 4.

snapp_input_maker.sh - Driver script for converting a VCF to diploid SNAPP input (i.e. Nexus input for processing in Beauti). Converts from VCF to haploid SNAPP using https://github.com/BEAST2-Dev/SNAPP/tree/master/script, then to diploid SNAPP using a custom python script (SNAPP_haploid_to_diploid.py), and finally adding lines for a new nexus file using sed commands. Requires a lot of manual file/value entering by user, but you should get the idea of it!

SNAPP_haploid_to_diploid.py - Script for converting a tab-delimited set of haploid nexus SNP data to diploid data. Takes and outputs "middle" lines, header and footer done by "snapp_input_maker.sh". Note that it's "dumb" and needs the input to be named "snapp_dip.txt" and outputs "snapp_out.txt".

$$$solsym_snapp95_limit.vcf - 95% complete VCF for SNAPP samples (4 Guadalcanal, 3 Malaita, 4 Kolombangara, 4 Makira, and 2 trivirgatus).

$$$solsym_limit95.nex - Nexus file used to make Beast XML for SNAPP.

$$$solsym_limit95.xml - Beast XML input file. Simply run with the line: beast -threads 20 solsym_limit95.xml.

$$$snap_limit95.trees - All trees from the SNAPP run.
_______________________________
------- UCEs Phylogenies ------
-------- (07_UCEs.zip) --------
_______________________________

NOTE: Phylogenetic analyses were run with the PAUP GUI (SVDQ) and Cipres (RAxML). Output in Figure 4.

run_phyluce_solo_triv.sh - Shell script for running PHYLUCE pipeline. Starts with cleaned reads and outputs Nexus and Phyllip files.

solsym_uce.conf - Taxon set .conf file. Used in several phyluce calls.

solsym_spades.conf - Spades .conf file, note paths are changed to generic ones up until clean reads folder. Used in phyluce_assembly_assemblo_spades.

$$$solsym_uce_contigs.tar.gz - All of the contigs.fa outputs from spades, tarballed and gzipped.

$$$sympos_uce_nexus_90.nexus - 90% complete nexus file used for SVDQuartets analysis.

sympos_uce_SVDQ_90.tre - Tree produced by SVDQ, combining samples by population.

$$$sympos_uce_raxml_90.phylip - 90% complete phylip file used for RAxML analysis.

sympos_uce_raxml.tre - Tree produced by RAxML, combining samples by population.
_______________________________
------------ DSuite -----------
------- (08_DSuite.zip) -------
_______________________________

NOTE: The topologies and popmaps have 6 consistent name corresponding to subfigures in Figure S3. A = main, B = noMal, C = conservative, D = conservative_noMal, E = malbar F = malbar_conservative.

run_D.sh - Shell script used for running Dsuite. The first one is used for the main ABBA/BABA results (Figure 5). The first and the rest are used for fbranch (Figure S3).

fbranch_topologies/* - Topologies used for fbranch.

pop_maps/* - Population maps used for the runs.
_______________________________
----------- msprime -----------
------ (09_msprime.zip) -------
_______________________________

msprime_bukida.pbs - Torque submission script used for running msprime simulations. Note that the first chunk (Choiseul/Isabel) was run, followed by the second (i.e., density list for second is dependent on results for first). Output in Figure 2.

bukida_msp.py - Python script used for simulations, documentation is all in there, but takes in island names (from main Bukida islands + Shortland, only three used), densities, and divergence time. Outputs Fst and nucleotide diversity (latter not used).

calc_mean_fst.sh - Quick script for calculating mean Fst for simulation output.

density_list_ChIs - Density list used for Choiseul and Isabel comparison.

density_list_IsGu - Density list used for Isabel and Guadalcanal comparison.
_______________________________
----- Photos of intergrade ----
------- (10_photos.zip) -------
_______________________________

All of these are photos of the intergrade (center), Ranongga samples (left two), and Kolombangara samples (right two).

