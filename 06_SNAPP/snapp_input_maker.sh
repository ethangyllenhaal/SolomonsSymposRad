#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 9 Feb 2022
# Wrapper shell script for converting a VCF file to SNAPP input.
# Uses the script below (vcf2nex.pl) to generate initial haploid (0/1) SNAPP input, which I convert here to the combined diploid (0/1/2) SNAPP input.
# Script link: https://github.com/BEAST2-Dev/SNAPP/tree/master/script
# Note that this is a quick and dirty script, and requires lots of values to be changed if you use this for your own data.

outname='limit95/solsym_limit95.nex'

# calls perl script to convert vcf to original nexus format
perl vcf2nex.pl < limit95/snapp95_limit.vcf > solsym_SNAPP_haploid.nex &&
# outputs the "data" lines of nexus file, second number is 5+N*2
sed -n '6,39p' solsym_SNAPP_haploid.nex > snapp_dip.txt &&
# runs python script to make "diploid" individuals for SNAPP
python3 SNAPP_haploid_to_diploid.py snapp_dip.txt &&
# adds nexus header to new nexus file
sed -n '1,5p' solsym_SNAPP_haploid.nex > $outname &&
# halves number of taxa (note that this has to be manually changed
sed -i -e 's/ntax=34/ntax=17/g' $outname &&
# changes symbols
sed -i -e 's/datatype=binary symbols="01"/datatype=standard symbols="012"/g' $outname &&
# adds output of python script to new nexus
cat snapp_out.txt >> $outname &&
# removes '_1" from names
sed -i -e 's/_1 / /g' $outname &&
# adds end of nexus file
echo ';\nEnd;' >> $outname
