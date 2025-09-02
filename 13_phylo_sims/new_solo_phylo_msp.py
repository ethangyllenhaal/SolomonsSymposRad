'''
Made by Ethan Gyllenhaal (egyllenhaal@unm.edu)
Last updated 10 Dec 2024

Script for running a single msprime simulation for static divergence between four islands (designed for parallel)
Takes in parameters for output path, alpha (# propagules per unit^2), and mean dispersal distance
Outputs a fasta for a subset of 3 individuals per island.

Island abbreviation key: B = Bukida Group, N = New Georgia Group, L = Malaita, K = Makira

run_msprime is the method for running the simulation and calculating summary statistics
calc_migration calculates relevant migration edges based on hard scripted parameters and a dispersal value
main is simply the driver for everything
'''

import os, sys, math, msprime as msp, numpy as np, re, argparse, tskit, allel

def main():
    
    # set up parser and arguments with ArgParse
    parse = argparse.ArgumentParser(description = "Get simulation parameters")
    parse.add_argument("-o", "--outstem", type=str, help="Path to output directory and stem")
    parse.add_argument("-d", "--dispersal", type=float, help="Value of mean dispersal distance in default units")
    parse.add_argument("-r", "--rep", type=int, help="Simulation replicate")
    parse.add_argument("-n", "--ne", type=float, help="Total pop size, split among islands")
    parse.add_argument("-t", "--time", type=float, help="Time to run after colonization is done")
    parse.add_argument("-i", "--interval", type=float, help="Interval of colonziation events")
    parse.add_argument("-f", "--first", type=str, help="String of first landing point, lowercase, currently 'mak' or 'buk'")
    args = parse.parse_args()
   
    # assign arguments to variables
    outstem, dispersal, repnum, total, time, interval, first  = args.outstem, args.dispersal, args.rep, args.ne, args.time, args.interval, args.first
    
    # calculate the population sizes and migration rates over time
    # uses calcParameters method below, used as input for msprime
    migrant_array = calc_migration(dispersal, total)
    print(dispersal, total)
    print(migrant_array)
    
    # population proportions in order Bukida, New Georgia, Malaita, Makira
    proportions = np.array([0.6489, 0.1616, 0.1020, 0.0875])
    popsize = total * proportions

    # calls msprime, assigns results to variables, and writes those to output
    muts = run_msprime(migrant_array, popsize, time, interval, first)
    muts.write_fasta(outstem + ".fasta")
    
    # also need to set in msprime driver
    samples = 3
    # get haplotypes from simulation
    haplotypes = np.array(muts.genotype_matrix())
    genotypes = allel.HaplotypeArray(haplotypes).to_genotypes(ploidy=2)
    countsB = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(0,samples)), max_allele=1)
    countsN = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(samples,samples*2)), max_allele=1)
    countsL = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(samples*2,samples*3)), max_allele=1)
    countsK = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(samples*3,samples*4)), max_allele=1)
    countsnoB = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(samples,samples*4)), max_allele=1)
    countsnoN = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(0,samples*1)) + list(range(samples*3,samples*4)), max_allele=1)
    countsnoL = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(0,samples*2)) + list(range(samples*3,samples*4)), max_allele=1)
    countsnoK = allel.HaplotypeArray(haplotypes).count_alleles(subpop=list(range(0,samples*3)), max_allele=1)

    # calcualte pi, sum of mean diffs divided by sequence length
    piB = np.nansum(allel.mean_pairwise_difference(countsB))/10000000
    piN = np.nansum(allel.mean_pairwise_difference(countsN))/10000000
    piL = np.nansum(allel.mean_pairwise_difference(countsL))/10000000
    piK = np.nansum(allel.mean_pairwise_difference(countsK))/10000000


    # private alleles
    privB = get_private(countsB.to_frequencies(), countsnoB.to_frequencies())
    privN = get_private(countsN.to_frequencies(), countsnoN.to_frequencies())
    privL = get_private(countsL.to_frequencies(), countsnoL.to_frequencies())
    privK = get_private(countsK.to_frequencies(), countsnoK.to_frequencies())

    stats = open(outstem + "_stats.txt", 'a')
    stats.write(str(piB) + "\t" + str(piN) + "\t" + str(piL) + "\t" + str(piK) + "\t" + 
                str(privB) + "\t" + str(privN) +"\t" + str(privL) +"\t" + str(privK) + "\n")

def run_msprime(migrants, sizes, time, interval, first):
    # set number of samples (wind up with 2 fasta/sample)
    samples=3

    # Set size and migration variables for clarity
    # Migration variables are backwards in time
    B_size, N_size, L_size, K_size = sizes
    N2B, L2B, K2B, B2N, B2L, K2L, B2K, L2K = migrants

    # Set up populations, with pop1 as Viti Levu and pop2 as Kadavu
    # Also makes an outgroup, size of 10k
    demography = msp.Demography()
    demography.add_population(name="Buk", initial_size=B_size, initially_active=True)
    demography.add_population(name="NG", initial_size=N_size, initially_active=True)
    demography.add_population(name="Mal", initial_size=L_size, initially_active=True)
    demography.add_population(name="Mak", initial_size=K_size, initially_active=True)
    demography.add_population(name="Out", initial_size=10000, initially_active=True)
    if(first=="mak"):
        demography.add_population_split(time=time+(3*interval), derived=["Mak"], ancestral="Out")
        demography.add_population_split(time=time+(2*interval), derived=["Mal"], ancestral="Mak")
        demography.add_population_split(time=time+interval, derived=["Buk"], ancestral="Mal")
        demography.add_population_split(time=time, derived=["NG"], ancestral="Buk")
        
    elif(first=="buk"):
        demography.add_population_split(time=time+(3*interval), derived=["Buk"], ancestral="Out")
        demography.add_population_split(time=time+(2*interval), derived=["NG"], ancestral="Buk")
        demography.add_population_split(time=time+interval, derived=["Mal"], ancestral="Buk")
        demography.add_population_split(time=time, derived=["Mak"], ancestral="Mal")
    
    # No dynamism! So just set migration rates
    # Note that migration is in #/gen, so needs to be divided by forward sink (backwards source) pop size
    demography.set_migration_rate(source="NG", dest="Buk", rate=N2B/N_size)
    demography.set_migration_rate(source="Mal", dest="Buk", rate=L2B/L_size)
    demography.set_migration_rate(source="Mak", dest="Buk", rate=K2B/K_size)
    demography.set_migration_rate(source="Buk", dest="NG", rate=B2N/B_size)
    demography.set_migration_rate(source="Buk", dest="Mal", rate=B2L/B_size)
    demography.set_migration_rate(source="Mak", dest="Mal", rate=K2L/K_size)
    demography.set_migration_rate(source="Buk", dest="Mak", rate=B2K/B_size)
    demography.set_migration_rate(source="Mal", dest="Mak", rate=L2K/L_size)
    
    # sort the demographic events
    demography.sort_events()

    # Run the simulation to get tree sequences
    trees=msp.sim_ancestry(samples={"Buk":samples, "NG":samples, "Mal":samples, "Mak":samples, "Out":samples}, 
                           demography=demography, 
                           recombination_rate=1e-8,
                           sequence_length=1e7)
                           
    # Add mutations to treeseqs
    mutation=msp.sim_mutations(trees, rate=4.6e-9, model="jc69")
    
    return(mutation)

def calc_migration(mean_disp, total):
    
    # alpha is hard set
    alpha = 0.00005
    # Load in arrays
    # Arrays forward in time: B2N, B2L, B2K, N2B, L2B, L2K, K2B, K2L
    # Arrays backwards in time (i.e. as used): N2B, L2B, K2B, B2N, B2L, K2L, B2K, L2K
    # Distance array and target size array from PleistoDist
    # (B2N and N2B are mean of Choi -> NG and Choi -> Vella)
    # L2B and B2L are mean of Mal to Ngella and Guad
    distances = np.array([56.89, 48.83, 64.31, 56.89, 48.83, 53.82, 64.31, 53.82])
    # targets; most from PleistoDist other than New Georgia <-> Bukida
    # NG target size was Kolo + NG + Vella in google maps
    # Bukida size is the main island of Choiseul
    # target of L -> B is Ngella and Guad summed
    targets = np.array([99.95, 159.9, 34.75, 161.6, 77.06, 40.30, 53.76, 38.89])
    # Source population proportion array
    # Proportion of individuals in spatial simulation from given islands after sizes stabalized in SLiM
    # Here adjacent islands are used to calculate source pop sizes
    # For B to N and L, B is Isa + Choi and Isa + Guad, respectively
    pop_prop = np.array([0.2236, 0.2172, 0.0981, 0.1616, 0.1020, 0.1020, 0.0875, 0.0875])
    # Calculate migration array
    migrants = alpha * total * pop_prop * ((targets * np.exp(-1 * 1/mean_disp * distances)) / (2 * np.pi * distances))

    return migrants

def get_private(focal, other):
    count = 0
    for i in range(0,len(focal)):
        if focal[i][1] < 1.0 and other[i][1] == 1.0:
            count+=1
        elif focal[i][1] > 0.0 and other[i][1] == 0.0:
            count+=1
    return count

if __name__ == '__main__':
    main()
    
