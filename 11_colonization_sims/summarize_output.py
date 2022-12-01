'''
Made by Ethan Gyllenhaal (egyllenhaal@unm.edu)
Last updated 7 November 2022

Script for summarizing output of occupation simulations
Desired output is run name and rough summaries of outcomes (i.e. what was colonized last)
Assumes name order of Bukida, New Georgia, Malaita, and Makira
Outputs summaries for number of successful colonizations, last island colonized proportions, and "paths"
Paths are the order islands were colonized, NOT explicit paths!
Output array order for successful/last colonized is Makira, Malaita, New Georgia, Bukida (sorry)
Usage: python summarize_output.py -i /path/to/input -o /path/to/output
'''

import sys, random, numbers, os, fnmatch, argparse, csv

def main():
    # initializing variables
    parse = argparse.ArgumentParser(description = "Get input and output")
    parse.add_argument("-i", "--input", type=str, help="Path to input directory")
    parse.add_argument("-o", "--output_stem", type=str, help="Path to output files")
    args = parse.parse_args()
    in_path, out_stem = args.input, args.output_stem

    # works through input files for successful colonization
    success_file = open("{0}_success.txt".format(out_stem), 'w')
    for file in os.listdir(in_path):
        # if file matches desired input name
        if fnmatch.fnmatch(file, "coltimes*.txt"):
            # initialize array of successful colonizations
            array = [0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally = 0
                # For each line, increment tally then check if island is colonized
                for str_line in inlines:
                    tally += 1
                    line = [int(i) for i in str_line]
                    # Check Makira
                    if line[3] < 10000:
                        array[0] += 1
                    # Check Malaita
                    if line[2] < 10000:
                        array[1] += 1
                    #Check New Georgia
                    if line[1] < 10000:
                        array[2] += 1
                    # Check Bukida
                    if line[0] < 10000:
                        array[3] += 1
                # write proportion of successful colonizations
                success_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" +
                                       str(array[2]/tally) + "\t"+ str(array[3]/tally) + "\n"))

    # works through input files for last colonized island
    last_file = open("{0}_last.txt".format(out_stem), 'w')
    for file in os.listdir(in_path):
        if fnmatch.fnmatch(file, "coltimes*.txt"):
            array = [0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally=0
                for str_line in inlines:
                    line = [int(i) for i in str_line]
                    # Check which island is strictly last 
                    # (i.e., ties don't count, and islands not colonized at the end can be "last"
                    # Order as above: Makira, Malita, New Georgia, Bukida
                    if line[3] > line[0] and line[3] > line[1] and line[3] > line[2]:
                        tally += 1
                        array[0] += 1
                    elif line[2] > line[0] and line[2] > line[1] and line[2] > line[3]:
                        tally += 1
                        array[1] += 1
                    elif line[1] > line[0] and line[1] > line[2] and line[1] > line[3]:
                        tally += 1
                        array[2] += 1
                    elif line[0] > line[1] and line[0] > line[2] and line[0] > line[3]:
                        tally += 1
                        array[3] += 1
                # write proportions of last colonizations
                if(tally>0):
                    last_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" + 
                                        str(array[2]/tally) + "\t"+ str(array[3]/tally) + "\n"))
                else:
                    last_file.write(str(params + "\t" + str(0) + "\t" + str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))
    
    # works through for colonization paths
    # runs seperately for NG and Bukida starts
    ng_file = open("{0}_ng_path.txt".format(out_stem), 'w')
    for file in os.listdir(in_path):
        if fnmatch.fnmatch(file, "coltimes*newgeorgia*.txt"):
            array = [0,0,0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally=0
                # for each line, check colonization order
                for str_line in inlines:
                    line = [int(i) for i in str_line]
                    # NG -> Bukida -> Malaita -> Makira
                    if line[1] < line[0] < line[2] < line[3]:
                        tally += 1
                        array[0] += 1
                    # NG -> Bukida -> Makira -> Malaita
                    elif line[1] < line[0] < line[3] < line[2]:
                        tally += 1
                        array[1] += 1
                    # NG -> Malaita -> Bukida -> Makira
                    elif line[1] < line[2] < line[0] < line[3]:
                        tally += 1
                        array[2] += 1
                    # NG -> Malaita -> Makira -> Bukida
                    elif line[1] < line[2] < line[3] < line[0]:
                        tally += 1
                        array[3] += 1
                    # NG -> Makira -> Bukida -> Malaita
                    elif line[1] < line[3] < line[0] < line[2]:
                        tally += 1
                        array[4] += 1
                    # NG -> Makira -> Malaita -> Bukida
                    elif line[1] < line[3] < line[2] < line[0]:
                        tally += 1
                        array[5] += 1
                # Write proportions and number of simulations checked to output
                if(tally>0):
                    ng_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" +
                                      str(array[2]/tally)  + "\t" + str(array[3]/tally)  + "\t" +
                                      str(array[4]/tally) + "\t"+ str(array[5]/tally) + "\t" + str(tally) + "\n"))
                else:
                    ng_file.write(str(params + "\t" + str(0) + "\t" + str(0) + "\t" + str(0) + "\t" + 
                                      str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))
    
    # overall like above
    buk_file = open("{0}_buk_path.txt".format(out_stem), 'w')
    for file in os.listdir(in_path):
        if fnmatch.fnmatch(file, "coltimes*bukida*.txt"):
            array = [0,0,0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally=0
                for str_line in inlines:
                    line = [int(i) for i in str_line]
                    # Bukida -> NG -> Malaita -> Makira
                    if line[0] < line[1] < line[2] < line[3]:
                        tally += 1
                        array[0] += 1
                    # Bukida -> NG -> Makira -> Malaita
                    elif line[0] < line[1] < line[3] < line[2]:
                        tally += 1
                        array[1] += 1
                    # Bukida -> Malaita -> NG -> Makira
                    elif line[0] < line[2] < line[1] < line[3]:
                        tally += 1
                        array[2] += 1
                    # Bukida -> Malaita -> Makira -> NG
                    elif line[0] < line[2] < line[3] < line[1]:
                        tally += 1
                        array[3] += 1
                    # Bukida -> Makira -> NG -> Malaita
                    elif line[0] < line[3] < line[1] < line[2]:
                        tally += 1
                        array[4] += 1
                    # Bukida -> Makira -> Malaita -> NG
                    elif line[0] < line[3] < line[2] < line[1]:
                        tally += 1
                        array[5] += 1
                if(tally>0):
                    buk_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" +
                                       str(array[2]/tally)  + "\t" + str(array[3]/tally)  + "\t" +
                                       str(array[4]/tally) + "\t"+ str(array[5]/tally) + "\t" + str(tally) + "\n"))
                else:
                    buk_file.write(str(params + "\t" + str(0) + "\t" + str(0) + "\t" + str(0) + "\t" + 
                                       str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))

if __name__ == '__main__':
    main()
            
