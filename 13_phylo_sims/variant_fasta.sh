#!/bin/bash


tr -d 'N' < $1 |
	grep '[A,G,T,C,>]' |
	tr -d '\n' |
	sed 's/>n[0-9][0-9]*/&\n/g' | 
	sed 's/>/\n>/g' | tail -n +2 > $2


sed -i 's/>n29/>Outgroup1/g' $2
sed -i 's/>n28/>Outgroup2/g' $2
sed -i 's/>n27/>Outgroup3/g' $2
sed -i 's/>n26/>Outgroup4/g' $2
sed -i 's/>n25/>Outgroup5/g' $2
sed -i 's/>n24/>Outgroup6/g' $2

sed -i 's/>n23/>Makira1/g' $2
sed -i 's/>n22/>Makira2/g' $2
sed -i 's/>n21/>Makira3/g' $2
sed -i 's/>n20/>Makira4/g' $2
sed -i 's/>n19/>Makira5/g' $2
sed -i 's/>n18/>Makira6/g' $2

sed -i 's/>n17/>Malaita1/g' $2
sed -i 's/>n16/>Malaita2/g' $2
sed -i 's/>n15/>Malaita3/g' $2
sed -i 's/>n14/>Malaita4/g' $2
sed -i 's/>n13/>Malaita5/g' $2
sed -i 's/>n12/>Malaita6/g' $2

sed -i 's/>n11/>NewGeorgia1/g' $2
sed -i 's/>n10/>NewGeorgia2/g' $2
sed -i 's/>n9/>NewGeorgia3/g' $2
sed -i 's/>n8/>NewGeorgia4/g' $2
sed -i 's/>n7/>NewGeorgia5/g' $2
sed -i 's/>n6/>NewGeorgia6/g' $2

sed -i 's/>n5/>Bukida1/g' $2
sed -i 's/>n4/>Bukida2/g' $2
sed -i 's/>n3/>Bukida3/g' $2
sed -i 's/>n2/>Bukida4/g' $2
sed -i 's/>n1/>Bukida5/g' $2
sed -i 's/>n0/>Bukida6/g' $2
