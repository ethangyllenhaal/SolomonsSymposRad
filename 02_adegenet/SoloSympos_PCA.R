##########
# By: Ethan Gyllenhaal
# Updated 9Feb2022
#
# R script used for generating PCAs for three subsets of Solomons Symposiachrus.
# Makes each PCA used in the paper, not that modifications were made in illustrator
# Then has one section for each relevant PCA.
# Per-section process described in the first section.
# Note that PDFs were made manually, not output to a file.
########

# load packages
library("adegenet")
library("ade4")
library("vcfR")
library("scales")
library("parallel")
library("viridis")
library("wesanderson")
setwd('/path/to/directory')

# formula for approximate p-values from "cell" in PCA
# p = 1 - exp( -[ c[cell]^2 /2 )
# 1.5 = 67%
# 2.5 = 95%


### 75% Solomons
# load in vcf, convert to genlight
solo_75_vcf <- read.vcfR("solsym_solomons_75.vcf")
solo_75_gl <- vcfR2genlight(solo_75_vcf)
# set population assignment, note that the # is just used for making sure populations corresponded to the colors I want
pop(solo_75_gl) <- c("6Choiseul", "6Choiseul", "6Choiseul", "3Guadalcanal", "3Guadalcanal", "3Guadalcanal", "3Guadalcanal", "5Isabel", "5Isabel", "5Isabel", "5Isabel", "5Isabel", "4Ngella", "4Ngella", "4Ngella", "4Ngella", "4Ngella", "7Shortlands", "7Shortlands", "7Shortlands", "2Malaita", "2Malaita", "2Malaita", "x3Kohinggo", "x3Kohinggo", "x3Kohinggo", "x1Kolombangra", "x1Kolombangra", "x1Kolombangra", "x1Kolombangra", "x1Kolombangra", "x2NewGeorgia", "9Ranongga", "9Ranongga", "9Ranongga", "x0Ranongga_hybrid", "x4Rendova", "x4Rendova", "x4Rendova", "x4Rendova", "x4Rendova", "x4Rendova", "x5Tetepare", "x5Tetepare", "x5Tetepare", "x5Tetepare", "x5Tetepare", "x5Tetepare", "8Vella", "8Vella", "8Vella", "8Vella", "1Makira", "1Makira", "1Makira", "1Makira", "1Makira")
# run PCA for 4 cores and 4 retained PCs
pca_75_solo <- glPca(solo_75_gl, n.cores=4, nf=4)
# makes un-classed PCA, useful for troubleshooting
scatter(pca_75_solo, cex=.25)
# makes classed PCA
s.class(pca_75_solo$scores[,1:2], pop(solo_75_gl), col=magma(15,begin=.1,end=.9), clab=1, cell=2.5)
# makes plot for PCs 2 and 3, figure not in paper
s.class(pca_75_solo$scores[,2:3], pop(solo_75_gl), col=magma(15,begin=.1,end=.9), clab=1, cell=2.5)
# make bar plot
barplot(pca_75_solo$eig/sum(pca_75_solo$eig), main="eigenvalues", col=heat.colors(length(pca_75_solo$eig)))
# print PC values
print(pca_75_solo$eig/sum(pca_75_solo$eig))


### 75% Bukida
bukida_75_vcf <- read.vcfR("solsym_bukida_75.vcf")
bukida_75_gl <- vcfR2genlight(bukida_75_vcf)
pop(bukida_75_gl) <- c("1Shortlands", "1Shortlands", "1Shortlands", "4Choiseul", "4Choiseul", "4Choiseul", "3Isabel", "3Isabel", "3Isabel", "3Isabel", "3Isabel", "2Ngella", "2Ngella", "2Ngella", "2Ngella", "2Ngella", "5Guadalcanal", "5Guadalcanal", "5Guadalcanal", "5Guadalcanal")
pca_75_bukida <- glPca(bukida_75_gl, n.cores=4, nf=4)
scatter(pca_75_bukida, cex=.25)
s.class(pca_75_bukida$scores[,1:2], pop(bukida_75_gl), col=wes_palette("Darjeeling1", 5, type="continuous"), clab=1, cell=2.5, pch=19)
barplot(pca_75_bukida$eig/sum(pca_75_bukida$eig), main="eigenvalues", col=heat.colors(length(pca_75_bukida$eig)))
print(pca_75_NG$eig/sum(pca_75_bukida$eig))

### 75% NG
NG_75_vcf <- read.vcfR("solsym_NG_75.vcf")
NG_75_gl <- vcfR2genlight(NG_75_vcf)
pop(NG_75_gl) <- c("4Kohinggo", "4Kohinggo", "4Kohinggo", "3Kolombangra", "3Kolombangra", "3Kolombangra", "3Kolombangra", "3Kolombangra", "5NewGeorgia", "7Ranongga", "7Ranongga", "7Ranongga", "6Ranongga_hybrid", "2Rendova", "2Rendova", "2Rendova", "2Rendova", "2Rendova", "2Rendova", "1Tetepare", "1Tetepare", "1Tetepare", "1Tetepare", "1Tetepare", "1Tetepare", "8Vella", "8Vella", "8Vella", "8Vella")
pca_75_NG <- glPca(NG_75_gl, n.cores=4, nf=4)
scatter(pca_75_NG, cex=.25)
s.class(pca_75_NG$scores[,1:2], pop(NG_75_gl), col=magma(8,begin=.1,end=.9), clab=1, cell=2.5)
s.class(pca_75_NG$scores[,2:3], pop(NG_75_gl), col=magma(8,begin=.1,end=.9), clab=1, cell=2.5)
barplot(pca_75_NG$eig/sum(pca_75_NG$eig), main="eigenvalues", col=heat.colors(length(pca_75_NG$eig)))
print(pca_75_NG$eig/sum(pca_75_NG$eig))


