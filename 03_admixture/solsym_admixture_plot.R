##########
# By: Ethan Gyllenhaal
# Updated 9Feb2022
#
# R script used for generating admixture plots for New Georgia samples.
# Makes Admixture bar plots
# Note that order and color of bars was changed in illustrator for clarity of demonstration.
########


setwd('/path/to/directory')

# NG group
NG2=read.table("NG_75_12.2.Q")
NG3=read.table("NG_75_12.3.Q")
NG4=read.table("NG_75_12.4.Q")
NG5=read.table("NG_75_12.5.Q")

par(mfrow=c(4,1), mar=c(0,2,0,0), oma=c(1,2,1,0))
# note that colors and order were changed in illustrator
barplot(t(as.matrix(NG2)), col=rainbow(6),ylab="Ancestry", border=NA)
barplot(t(as.matrix(NG3)), col=rainbow(6),ylab="Ancestry", border=NA)
barplot(t(as.matrix(NG4)), col=rainbow(6),xlab="Individual #", ylab="Ancestry", border=NA)
barplot(t(as.matrix(NG5)), col=rainbow(6),xlab="Individual #", ylab="Ancestry", border=NA)
