#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 23 Aug 2022
# Wrapper shell script for converting a VCF file to SNAPP input.
# Uses the script below (vcf2nex.pl) to generate initial haploid (0/1) SNAPP input, which I convert here to the combined diploid (0/1/2) SNAPP input.
# Script link: https://github.com/BEAST2-Dev/SNAPP/tree/master/script
# Note that this is a quick and dirty script, and requires lots of values to be changed if you use this for your own data.
# Takes in vcf input name ($1), outstem ($2) and sample number ($3)


outname=$2

endline=$(( $3 * 2 + 5 ))
export LANG=C

# calls perl script to convert vcf to original nexus format
# then outputs the "data" lines of nexus file, second number is 5+N*2
perl vcf2nex.pl < $1 >  ${outname}_temp.nex
sed -n "6,${endline}p" ${outname}_temp.nex > ${outname}_haploid.txt &&

# runs python script to make "diploid" individuals for SNAPP
python3 SNAPP_haploid_to_diploid.py ${outname}_haploid.txt ${outname}_diploid.txt &&

# adds nexus header to new nexus file
sed -n '1,5p' ${outname}_temp.nex > $outname.nex &&

# halves number of taxa (note that this has to be manually changed
sed -i -e "s/ntax=$(( $3 * 2 ))/ntax=${3}/g" $outname.nex &&

# changes symbols
sed -i -e 's/datatype=binary symbols="01"/datatype=standard symbols="012"/g' $outname.nex &&

# adds output of python script to new nexus
cat ${outname}_diploid.txt >> $outname.nex &&

# removes '_1" from names
sed -i -e 's/_1 / /g' $outname.nex &&

# adds end of nexus file
echo ';\nEnd;' >> $outname.nex

# removes temp files
rm ${outname}_temp.nex
rm ${outname}_haploid.txt
rm ${outname}_diploid.txt
