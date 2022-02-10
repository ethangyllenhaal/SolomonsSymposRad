#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 9 February 2022
# Very simple script to run a basic awk column summer for all files in the output directory

for file in ~/msprime/updated_msp/output/*/*
do
    printf "$file\t$(awk -F'\t' '{sum+=$4; n++} END{print sum/n;}' $file)\n"
done
