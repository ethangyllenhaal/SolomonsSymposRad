#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 7 November 2022
# Shell script for removing invariant sites from fasta output by MSPrime
# Also adds sensible sample names
# $1 is input, $2 is output file

# Does the work of getting rid of invariant (N) sites.
tr -d 'N' < $1 |
	grep '[A,G,T,C,>]' |
	tr -d '\n' |
	sed 's/>n[0-9][0-9]*/&\n/g' | 
	sed 's/>/\n>/g' | tail -n +2 > $2

# replaces default names with "sample" names
sed -i 's/>n19/>Outgroup1/g' $2
sed -i 's/>n18/>Outgroup2/g' $2
sed -i 's/>n17/>Outgroup3/g' $2
sed -i 's/>n16/>Outgroup4/g' $2
sed -i 's/>n15/>Makira1/g' $2
sed -i 's/>n14/>Makira2/g' $2
sed -i 's/>n13/>Makira3/g' $2
sed -i 's/>n12/>Makira4/g' $2
sed -i 's/>n11/>Malaita1/g' $2
sed -i 's/>n10/>Malaita2/g' $2
sed -i 's/>n9/>Malaita3/g' $2
sed -i 's/>n8/>Malaita4/g' $2
sed -i 's/>n7/>NewGeorgia1/g' $2
sed -i 's/>n6/>NewGeorgia2/g' $2
sed -i 's/>n5/>NewGeorgia3/g' $2
sed -i 's/>n4/>NewGeorgia4/g' $2
sed -i 's/>n3/>Bukida1/g' $2
sed -i 's/>n2/>Bukida2/g' $2
sed -i 's/>n1/>Bukida3/g' $2
sed -i 's/>n0/>Bukida4/g' $2
