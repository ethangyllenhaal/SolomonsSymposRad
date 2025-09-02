# By: Ethan Gyllenhaal (egyllenh@ttu.edu)
#
# R script for making simple plots of additional summary stats of simulations (msprime and SLiM)

# load libraries, set working dir
library(ggplot2)
library(dplyr)
library(gridExtra)
library(viridis)
library(data.table)
library(reshape2)
library(ggbeeswarm)
setwd('C:/Documents/Projects/SoloSymposRad/arch_msp/slim_msp_summstats')

# function for making a box plot of nuleotide diversity from SLiM data
# note that this is... not a great way to do this, as no burnin was conducted
## (diversity wasn't the focus of the simulation)
make_slim_piplot <- function(input){
  data <- read.csv(input, header=TRUE, sep="\t")
  
  data[data < 0] <- NA
  data <- data[,c(4,1,2,3)]

  melt <- melt(data, variable.name = 'island')
  color_values <- c("#009949", "#F06623","#C1B49B", "#AA50B4")
  plot <- ggplot(melt, aes(x=island, y = value, group=island, color = island, fill = island)) +
    geom_boxplot(show.legend=FALSE, notch=FALSE, lwd = 0.3, outlier.size = 0.7) + 
    theme_bw(base_size = 10) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
    ggtitle(input) +
    scale_color_manual(values = color_values) + scale_fill_manual(values = alpha(color_values, 0.5))
  plot
  return(plot)
}

# function for making a box plot of private alleles  from SLiM data
# note that this is... not a great way to do this, as no burnin was conducted
## (diversity wasn't the focus of the simulation)
make_slim_privplot <- function(input){
  data <- read.csv(input, header=TRUE, sep="\t")
  
  data[data < 0] <- NA
  data <- data[,c(8,5,6,7)]
  
  melt <- melt(data, variable.name = 'island')
  color_values <- c("#009949", "#F06623","#C1B49B", "#AA50B4")
  plot <- ggplot(melt, aes(x=island, y = value, group=island, color = island, fill = island)) +
    geom_boxplot(show.legend=FALSE, notch=FALSE, lwd = 0.3, outlier.size = 0.7) + 
    theme_bw(base_size = 10) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
    ggtitle(input) +
    scale_color_manual(values = color_values) + scale_fill_manual(values = alpha(color_values, 0.5))
  plot
  return(plot)
}

# function for making a plot of colonization sources from SLiM data
# Note that source pop is assigned as an integer tag value
# Mixed founders can be assigned based on some simplifying assumptions (ie, adjacent only)
## and some algebra
# New Georgia = 1, Malaita 2, Makira = 3, Bukida = 0, other = -100
make_slim_sourceplot <- function(input){
  data <- read.csv(input, header=TRUE, sep="\t")
  data <- data[c(4,1,2,3)]
  #data[data < 0] <- NA
  melt <- melt(data, variable.name = 'island')
  color_values <- c("#009949", "#F06623","#C1B49B", "#AA50B4")
  plot <- ggplot(melt, aes(x=island, y = value, group=island, color = island, fill = island)) +
    geom_boxplot(show.legend=FALSE, notch=FALSE, lwd = 0.3, outlier.size = 0.7) + 
    theme_bw(base_size = 10) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
    ggtitle(input) +
    scale_color_manual(values = color_values) + scale_fill_manual(values = alpha(color_values, 0.5))
  plot
  return(plot)
}

# function for making plot of pi from msp data
make_msp_piplot <- function(dispersal, hist){
  data <- read.csv("sumstat_combined.txt", header=F, sep="\t")
  colnames(data) <- c("disp", "ne", "time", "int", "type", "rep", "piB", "piN", "piL", "piK", "privB", "privN", "privL", "privK")
  subset <- data %>%
    filter(ne==50000 & int==25000 & time==200000 & type==hist & disp==dispersal) %>%
    select(piB, piN, piL, piK) %>%
    melt(variable.name = 'island')
  
  color_values <- c("#009949", "#F06623","#C1B49B", "#AA50B4")
  plot <- ggplot(subset, aes(x=island, y = value, group=island, color = island, fill = island)) +
    geom_boxplot(show.legend=FALSE, notch=FALSE, lwd = 0.3, outlier.size = 0.7) + 
    theme_bw(base_size = 10) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
    ggtitle(paste(dispersal,hist)) +
    scale_color_manual(values = color_values) + scale_fill_manual(values = alpha(color_values, 0.5))
  plot
  return(plot)
}
# function for making plot of private alleles from msp data
make_msp_privplot <- function(dispersal, hist){
  data <- read.csv("sumstat_combined.txt", header=F, sep="\t")
  colnames(data) <- c("disp", "ne", "time", "int", "type", "rep", "piB", "piN", "piL", "piK", "privB", "privN", "privL", "privK")
  subset <- data %>%
    filter(ne==50000 & int==25000 & time==200000 & type==hist & disp==dispersal) %>%
    select(privB, privN, privL, privK) %>%
    melt(variable.name = 'island')
  color_values <- c("#009949", "#F06623","#C1B49B", "#AA50B4")
  plot <- ggplot(subset, aes(x=island, y = value, group=island, color = island, fill = island)) +
    geom_boxplot(show.legend=FALSE, notch=FALSE, lwd = 0.3, outlier.size = 0.7) + 
    theme_bw(base_size = 10) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) + 
    ggtitle(paste(dispersal,hist)) +
    scale_color_manual(values = color_values) + scale_fill_manual(values = alpha(color_values, 0.5))
  plot
  return(plot)
}


# SLiM pi
d200_pi <- make_slim_piplot("sumstats_d200.txt")+ylim(0,0.0025)
d400_pi <- make_slim_piplot("sumstats_d400.txt")+ylim(0,0.0025)
d600_pi <- make_slim_piplot("sumstats_d600.txt")+ylim(0,0.0025)
d800_pi <- make_slim_piplot("sumstats_d800.txt")+ylim(0,0.0025)
d1000_pi <- make_slim_piplot("sumstats_d1000.txt")+ylim(0,0.0025)
d1200_pi <- make_slim_piplot("sumstats_d1200.txt")+ylim(0,0.0025)
d1600_pi <- make_slim_piplot("sumstats_d1600.txt")+ylim(0,0.0025)
grid.arrange(d400_pi, d600_pi, d800_pi, d1000_pi, d1200_pi, d1600_pi, ncol=2, bottom="Island")

# SLiM private alleles
d200_priv <- make_slim_privplot("sumstats_d200.txt") + ylim(c(0,650))
d400_priv <- make_slim_privplot("sumstats_d400.txt")+ ylim(c(0,650))
d600_priv <- make_slim_privplot("sumstats_d600.txt")+ ylim(c(0,650))
d800_priv <- make_slim_privplot("sumstats_d800.txt")+ ylim(c(0,650))
d1000_priv <- make_slim_privplot("sumstats_d1000.txt")+ ylim(c(0,650))
d1200_priv <- make_slim_privplot("sumstats_d1200.txt")+ ylim(c(0,650))
d1600_priv <- make_slim_privplot("sumstats_d1600.txt")+ ylim(c(0,650))
grid.arrange(d400_priv, d600_priv, d800_priv, d1000_priv, d1200_priv, d1600_priv, ncol=2, bottom="Island")

# SLiM Source
# New Georgia = 1, Malaita 2, Makira = 3, Bukida = 0, other = -100
# note that ylim excludes ones with a source outside of the Solomons
d200_source <- make_slim_sourceplot("source_d200.txt")+ylim(0,3)
d400_source <- make_slim_sourceplot("source_d400.txt")+ylim(0,3)
d600_source <- make_slim_sourceplot("source_d600.txt")+ylim(0,3)
d800_source <- make_slim_sourceplot("source_d800.txt")+ylim(0,3)
d1000_source <- make_slim_sourceplot("source_d1000.txt")+ylim(0,3)
d1200_source <- make_slim_sourceplot("source_d1200.txt")+ylim(0,3)
d1600_source <- make_slim_sourceplot("source_d1600.txt")+ylim(0,3)
grid.arrange(d400_source, d600_source, d800_source, d1000_source, d1200_source, d1600_source, ncol=2, bottom="Island")

# msprime pi
d0_msp_pi <- make_msp_piplot(0.0001, "buk") + ylim(c(0,0.001))
d10_msp_pi <- make_msp_piplot(10, "buk") + ylim(c(0,0.001))
d15_msp_pi <- make_msp_piplot(15, "buk") + ylim(c(0,0.001))
d20_msp_pi <- make_msp_piplot(20, "buk") + ylim(c(0,0.001))
d30_msp_pi <- make_msp_piplot(30, "buk") + ylim(c(0,0.001))
d40_msp_pi <- make_msp_piplot(40, "buk") + ylim(c(0,0.001))
d60_msp_pi <- make_msp_piplot(60, "buk") + ylim(c(0,0.001))
d80_msp_pi <- make_msp_piplot(80, "buk") + ylim(c(0,0.001))
d100_msp_pi <- make_msp_piplot(100, "buk") + ylim(c(0,0.001))

grid.arrange(d0_msp_pi, d10_msp_pi, d15_msp_pi, d20_msp_pi, d30_msp_pi, d40_msp_pi, d80_msp_pi, d100_msp_pi, ncol=2)

# msprime priv
d0_msp_priv <- make_msp_privplot(0.0001, "buk") + ylim(c(500,6000))
d10_msp_priv <- make_msp_privplot(10, "buk") + ylim(c(500,6000))
d15_msp_priv <- make_msp_privplot(15, "buk") + ylim(c(500,6000))
d20_msp_priv <- make_msp_privplot(20, "buk") + ylim(c(500,6000))
d30_msp_priv <- make_msp_privplot(30, "buk") + ylim(c(500,6000))
d40_msp_priv <- make_msp_privplot(40, "buk") + ylim(c(500,6000))
d60_msp_priv <- make_msp_privplot(60, "buk") + ylim(c(500,6000))
d80_msp_priv <- make_msp_privplot(80, "buk") + ylim(c(500,6000))
d100_msp_priv <- make_msp_privplot(100, "buk") + ylim(c(500,6000))

grid.arrange(d0_msp_priv, d10_msp_priv, d15_msp_priv, d20_msp_priv, d30_msp_priv, d40_msp_priv, d80_msp_priv, d100_msp_priv, ncol=2)


# msprime pi makira
d0_msp_pi_mak <- make_msp_piplot(0.0001, "mak") + ylim(c(0,0.001))
d10_msp_pi_mak <- make_msp_piplot(10, "mak") + ylim(c(0,0.001))
d15_msp_pi_mak <- make_msp_piplot(15, "mak") + ylim(c(0,0.001))
d20_msp_pi_mak <- make_msp_piplot(20, "mak") + ylim(c(0,0.001))
d30_msp_pi_mak <- make_msp_piplot(30, "mak") + ylim(c(0,0.001))
d40_msp_pi_mak <- make_msp_piplot(40, "mak") + ylim(c(0,0.001))
d60_msp_pi_mak <- make_msp_piplot(60, "mak") + ylim(c(0,0.001))
d80_msp_pi_mak <- make_msp_piplot(80, "mak") + ylim(c(0,0.001))
d100_msp_pi_mak <- make_msp_piplot(100, "mak") + ylim(c(0,0.001))

grid.arrange(d0_msp_pi_mak, d10_msp_pi_mak, d15_msp_pi_mak, d20_msp_pi_mak, d30_msp_pi_mak, d40_msp_pi_mak, d80_msp_pi_mak, d100_msp_pi_mak, ncol=2)

# msprime priv makira
d0_msp_priv_mak <- make_msp_privplot(0.0001, "mak") + ylim(c(500,6000))
d10_msp_priv_mak <- make_msp_privplot(10, "mak") + ylim(c(500,6000))
d15_msp_priv_mak <- make_msp_privplot(15, "mak") + ylim(c(500,6000))
d20_msp_priv_mak <- make_msp_privplot(20, "mak") + ylim(c(500,6000))
d30_msp_priv_mak <- make_msp_privplot(30, "mak") + ylim(c(500,6000))
d40_msp_priv_mak <- make_msp_privplot(40, "mak") + ylim(c(500,6000))
d60_msp_priv_mak <- make_msp_privplot(60, "mak") + ylim(c(500,6000))
d80_msp_priv_mak <- make_msp_privplot(80, "mak") + ylim(c(500,6000))
d100_msp_priv_mak <- make_msp_privplot(100, "mak") + ylim(c(500,6000))

grid.arrange(d0_msp_priv_mak, d10_msp_priv_mak, d15_msp_priv_mak, d20_msp_priv_mak, d30_msp_priv_mak, d40_msp_priv_mak, d80_msp_priv_mak, d100_msp_priv_mak, ncol=2)

grid.arrange(d0_msp_pi, d40_msp_pi, d80_msp_pi, d0_msp_pi_mak, d40_msp_pi_mak, d80_msp_pi_mak, d0_msp_priv, d40_msp_priv, d80_msp_priv, d0_msp_priv_mak, d40_msp_priv_mak, d80_msp_priv_mak, nrow=4)


## Makira explore ####
est_mak_bukprop <- function(input){
  df <- read.csv(input, header=TRUE, sep="\t") %>%
    melt(variable.name = 'island') %>%
    filter(island=="makira" & value >= 0 ) %>%
    mutate(buk_prop = (value)/2)
  return(df)
}

bp400 <- est_mak_bukprop("source_d400.txt")
bp600 <- est_mak_bukprop("source_d600.txt")
bp800 <- est_mak_bukprop("source_d800.txt")
bp1000 <- est_mak_bukprop("source_d1000.txt")
bp1200 <- est_mak_bukprop("source_d1200.txt")
bp1600 <- est_mak_bukprop("source_d1600.txt")

# non-mixed
nrow(filter(bp400, value > 0.9 | value <0.1)) / nrow(bp400)
nrow(filter(bp600, value > 0.9 | value <0.1)) / nrow(bp600)
nrow(filter(bp800, value > 0.9 | value <0.1)) / nrow(bp800)
nrow(filter(bp1000, value > 0.9 | value <0.1)) / nrow(bp1000)
nrow(filter(bp1200, value > 0.9 | value <0.1)) / nrow(bp1200)
nrow(filter(bp1600, value > 0.9 | value <0.1)) / nrow(bp1600)

# mostly Bukida
nrow(filter(bp400, value <0.1)) / nrow(bp400)
nrow(filter(bp600, value <0.1)) / nrow(bp600)
nrow(filter(bp800, value <0.1)) / nrow(bp800)
nrow(filter(bp1000, value <0.1)) / nrow(bp1000)
nrow(filter(bp1200, value <0.1)) / nrow(bp1200)
nrow(filter(bp1600, value <0.1)) / nrow(bp1600)

# mostly Malaita
nrow(filter(bp400, value >0.9)) / nrow(bp400)
nrow(filter(bp600, value >0.9)) / nrow(bp600)
nrow(filter(bp800, value >0.9)) / nrow(bp800)
nrow(filter(bp1000, value >0.9)) / nrow(bp1000)
nrow(filter(bp1200, value >0.9)) / nrow(bp1200)
nrow(filter(bp1600, value >0.9)) / nrow(bp1600)