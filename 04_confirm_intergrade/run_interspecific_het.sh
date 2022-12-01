#!/bin/bash


# By: Ethan Gyllenhaal
# Last updated: 7 November 2022
# Shell script for subsetting to diagnostic SNPS and counting heterozygotes in target sample
# I run this with a conda environment with vcftools installed.

# VCFtools to get SNP FST
vcftools --vcf solsym_solomons_75.vcf --weir-fst-pop kolo_etc_samples --weir-fst-pop rano_vella_samples \
	--remove-filtered-all --min-alleles 2 --max-alleles 2 --max-missing 1 \
	--out interspecific_fst_output
	
# select SNPs with an FST of 1
awk '$3 != "-nan" && $3 == 1 {printf $1"\t"$2"\n"}' interspecific_fst_output.weir.fst > \
    interspecific_target_snps

# limit VCF to SNPs with FST of 1
vcftools --vcf solsym_solomons_75.vcf  --keep keep_interspecific --positions interspecific_target_snps \
	--012 --remove-filtered-all --max-missing 1 --min-alleles 2 --max-alleles 2 \
	--out interspecific_input

# get last of the fixed SNP input (focal indiv), remove the first column, convert tabs to newline (transpose)
tail -n1 interspecific_input.012 | cut -f2- interspecific_input.012 | tr '\t' '\n' > interspecific_column
# set variables for heterozygotes (1 in 012 format) and the total number of SNPs
het=$(grep '1' interspecific_column | wc -l)
total=$(cat interspecific_column | wc -l)
# print the result
awk "BEGIN {print $het/$total}"