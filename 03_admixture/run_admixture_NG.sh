#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 9 February 2022
# Shell script for running admixture.
# Starts with non-12 formatted Plink ped and map files.
# I run this with a conda environment with plink and admixture installed.

# Convert .ped and .map into 12 formatted .ped and .map
plink --file solsym_NG_75 --allow-extra-chr --recode 12 --out solsym_NG_75_12

# run Admixture
for K in 1 2 3 4 5; \
	do admixture -m EM --cv solsym_NG_75_12.ped ${K} | tee k_log${K}.out; done
# spit out K values
grep -h CV k_log*.out > solsym_NG_kval