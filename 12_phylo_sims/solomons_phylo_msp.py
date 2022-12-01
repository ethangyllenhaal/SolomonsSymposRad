'''
Made by Ethan Gyllenhaal (egyllenhaal@unm.edu)
Last updated 7 November 2022

Script for running a single msprime simulation for static divergence between four islands (designed for parallel)
Takes in parameters for output path, replicate #, and mean dispersal distance
Alpha (# propagules per unit^2) is hard set at 5e-5
Outputs a fasta for a subset of 10 individuals per island.

Island abbreviation key: B = Bukida Group, N = New Georgia Group, L = Malaita, K = Makira

run_msprime is the method for running the simulation and calculating summary statistics
calc_migration calculates relevant migration edges based on hard scripted parameters and a dispersal value
main is simply the driver for everything
'''

import os, sys, math, msprime as msp, numpy as np, re, argparse, tskit

# global for total population size
total = 200000

def main():
    
    # set up parser and arguments with ArgParse
    parse = argparse.ArgumentParser(description = "Get simulation parameters")
    parse.add_argument("-o", "--output", type=str, help="Path to output file")
    parse.add_argument("-d", "--dispersal", type=float, help="Value of mean dispersal distance in default units")
    parse.add_argument("-r", "--rep", type=float, help="Simulation replicate")
    args = parse.parse_args()
   
    # assign arguments to variables
    outpath, dispersal, repnum = args.output, args.dispersal, args.rep
    
    # calculate the population sizes and migration rates over time
    # uses calcParameters method below, used as input for msprime
    migrant_array = calc_migration(dispersal)
    print(migrant_array)

    # amount of generations to run the simulation for (full time, for this split are established for 850k generations
    time = 1000000
    
    # population proportions in order Bukida, New Georgia, Malaita, Makira
    proportions = np.array([0.650905781, 0.170139551, 0.085958221, 0.090335442])
    popsize = total * proportions

    # calls msprime, assigns results to variables, and writes those to output
    fastas = run_msprime(migrant_array, popsize, time)
    fastas.write_fasta(outpath)
    
def run_msprime(migrants, sizes, time):
    # set number of samples (wind up with 2 fasta/sample)
    samples=2

    # Set size and migration variables for clarity
    # Migration variables are backwards in time
    B_size, N_size, L_size, K_size = sizes
    N2B, L2B, K2B, B2N, B2L, K2L, B2K, L2K = migrants

    # Set up populations, with pop1 as Viti Levu and pop2 as Kadavu
    # Also makes an outgroup, size of 10k
    demography = msp.Demography()
    demography.add_population(name="Buk", initial_size=B_size)
    demography.add_population(name="NG", initial_size=N_size)
    demography.add_population(name="Mal", initial_size=L_size)
    demography.add_population(name="Mak", initial_size=K_size)
    demography.add_population(name="Out", initial_size=10000)

    # Set up population splits, note gene flow only occurs between "final" populations
    demography.add_population(name="anc_pop", initial_size = 10000)
    demography.add_population(name="anc_N", initial_size = N_size)
    demography.add_population(name="anc_B", initial_size = B_size)
    demography.add_population(name="anc_L", initial_size = L_size)
    demography.add_population_split(time=time, derived=["Out", "anc_N"], ancestral="anc_pop")
    demography.add_population_split(time=time-50000, derived=["NG", "anc_B"], ancestral="anc_N")
    demography.add_population_split(time=time-100000, derived=["Buk", "anc_L"], ancestral="anc_B")
    demography.add_population_split(time=time-150000, derived=["Mal", "Mak"], ancestral="anc_L")
                                        
    
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
    mutation=msp.sim_mutations(trees, rate=2.3e-9)
    
    return(mutation)

def calc_migration(mean_disp):
    
    # alpha is hard set 0.0001 for 200k, 20 migrants
    #alpha = 0.0001
    alpha = 0.00005 # 10 migrants
    # Load in arrays
    # Arrays forward in time: B2N, B2L, B2K, N2B, L2B, L2K, K2B, K2L
    # Arrays backwards in time (i.e. as used): N2B, L2B, K2B, B2N, B2L, K2L, B2K, L2K
    # Distance array and target size array from google maps
    distances = np.array([52.34,41.762373,60.72,52.34,41.762373,55.74,60.72,55.74])
    # targets; main first, broad second
    targets = np.array([115.88, 190.71, 29.14, 177.45, 119.41, 107.76, 42.28, 41.54])
    #broad_targets = np.array([231.38, 190.65, 41.19, 284.17, 216.45, 125.64, 51.97, 66.09])
    # Source population proportion array
    # Proportion of individuals in spatial simulation from given islands after sizes stabalized
    # Bukida is divided by 4 to account for its length
    #pop_prop = np.array([0.1627, 0.1627, 0.1627, 0.1701, 0.08596, 0.08596, 0.09034, 0.09034])
    # Here adjacent islands are used to calculate source pop sizes
    pop_prop = np.array([0.1115, 0.1066, 0.1066, 0.1701, 0.08596, 0.08596, 0.09034, 0.09034])
    # Calculate migration array
    migrants = alpha * total * pop_prop * ((targets * np.exp(-1 * 1/mean_disp * distances)) / (2 * np.pi * distances))

    return migrants

if __name__ == '__main__':
    main()
    
