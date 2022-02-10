import os, sys, msprime as msp, numpy as np, re, allel, argparse, pandas

'''
Made by Ethan Gyllenhaal (egyllenhaal@unm.edu)
Last updated 9 Feb 2022

Script for running Solomon Island msprime simulations, using msprime v1.
main method processes arguments, sets population sizes, calls msprime, and writes simulated parameters to output.
msprime method runs msprime simulation based on parameters parsed from main.
gitIslandSize method takes the island size of a given island and uses its size and set density to get Ne.
Islands supported: Guadalcanal, Bougainville, Ngella, Shortland, Choiseul, and Isabel.
Only three are used in the paper.
Usage: python bukida_msp.py -i1 Island1 -i2 Island2 -d1 Density1 -d2 Density2 -t DivergenceTime -o /path/to/output
'''

def main():
    # set up parser and arguments
    parse = argparse.ArgumentParser(description = "Get simulation parameters")
    parse.add_argument("-i1", "--island1", type=str, help="First island name")
    parse.add_argument("-i2", "--island2", type=str, help="Second island name")
    parse.add_argument("-d1", "--density1", type=float, help="Density of first population")
    parse.add_argument("-d2", "--density2", type=float, help="Density of second population")
    parse.add_argument("-t", "--divtime", type=int, help="Divergence time in # generations")
    parse.add_argument("-o", "--output", type=str, help="Path to output file")
    args = parse.parse_args()
   
    # assign arguments to variables
    island1, island2, dens1, dens2, time, outfile = args.island1, args.island2, args.density1, args.density2, args.divtime, args.output

    # get population sizes
    pop1 = dens1 * getIslandSize(island1)
    pop2 = dens2 * getIslandSize(island2)


    # calls msprime and prints results to output
    fst, div1, div2 = msprime(pop1, pop2, time)
    output = open(outfile, "a")
    output.write(str(int(pop1))+"\t"+str(int(pop2))+"\t"+str(time)+"\t"+str(fst)+"\t"+str(div1)+"\t"+str(div2)+"\n")
    output.close()
    
def msprime(size1, size2, time):
    # set number of samples
    samples=30

    # make demography object
    demography = msp.Demography()
    # make population 1
    demography.add_population(name="pop1", initial_size=size1)
    # make population 2
    demography.add_population(name="pop2", initial_size=size2)
    # make ancestral pop
    demography.add_population(name="anc_pop12", initial_size=size1+size2)
    # set up population split
    demography.add_population_split(time=time, derived=["pop1","pop2"], ancestral="anc_pop12")

    # simulate ancestry to make trees
    trees=msp.sim_ancestry(samples={"pop1":samples, "pop2":samples}, 
                           demography=demography, 
                           recombination_rate=1e-8,
                           sequence_length=1e7)

    # add mutations to treeseq
    mutation=msp.sim_mutations(trees, rate=2.3e-9)
    
    # get haplotypes from simulation 
    haplotypes = np.array(mutation.genotype_matrix())
    positions = np.array([s.position for s in trees.sites()])
    genotypes = allel.HaplotypeArray(haplotypes).to_genotypes(ploidy=2)
    
    # calculate fst
    fst = allel.stats.fst.average_weir_cockerham_fst(genotypes,[list(range(0,int(samples))),list(range(int(samples),samples*2))],10)[0]
    
    # calculate diversity (not used in paper)
    geno1 = genotypes.take(range(0,int(samples)),axis=1)
    geno2 = genotypes.take(range(int(samples),int(samples*2)), axis=1)
    acount1 = geno1.count_alleles()
    acount2 = geno2.count_alleles()
    div1 = allel.sequence_diversity(range(1,len(acount1)),acount1)
    div2 = allel.sequence_diversity(range(1,len(acount2)),acount2)
    
    # return the summary statistics
    return(fst, div1, div2)

def getIslandSize(island):
    # method for getting island sizes, assumes the island names are one of these six
    if(island=="Guadalcanal"):
        return(5302)
    elif(island=="Bougainville"):
        return(9318)
    elif(island=="Ngella"):
        return(276)
    elif(island=="Shortland"):
        return(163)
    elif(island=="Choiseul"):
        return(2971)
    elif(island=="Isabel"):
        return(2999)
    else:
        print("Bad island name")
        return(-1)

if __name__ == '__main__':
    main()
