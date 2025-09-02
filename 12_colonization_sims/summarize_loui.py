# Script for summarizing output of occupation simulations
# Desired output is run name and rough summaries of outcomes (i.e. what was colonized last)
## name,ng,mal,mak,buk
# Down the road maybe I can do colonization route summaries?

# Pseudocode
# for file in output_modified
## array = [0,0,0,0] = [ng, mal, mak, buk]
## for line in file
### if makira is strictly the greatest, increment array[0]
#### repeat for other array sections

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
        if fnmatch.fnmatch(file, "coltimes*.txt"):
            array = [0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally = 0
                for str_line in inlines:
                    tally += 1
                    line = [int(i) for i in str_line]
                    if line[3] < 30000:
                        array[0] += 1
                    if line[2] < 30000:
                        array[1] += 1
                    if line[1] < 30000:
                        array[2] += 1
                    if line[0] < 30000:
                        array[3] += 1
                tally = float(tally)
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
                    if line[0] > line[1] and line[0] > line[2] and line[0] > line[3]:
                        tally += 1
                        array[0] += 1
                    elif line[1] > line[0] and line[1] > line[2] and line[1] > line[3]:
                        tally += 1
                        array[1] += 1
                    elif line[2] > line[0] and line[2] > line[1] and line[2] > line[3]:
                        tally += 1
                        array[2] += 1
                    elif line[3] > line[1] and line[3] > line[2] and line[3] > line[0]:
                        tally += 1
                        array[3] += 1
                tally = float(tally)
                if(tally>0):
                    last_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" + 
                                        str(array[2]/tally) + "\t"+ str(array[3]/tally) + "\n"))
                else:
                    last_file.write(str(params + "\t" + str(0) + "\t" + str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))
    
    # work through files and find first colonized
    first_file = open("{0}_first.txt".format(out_stem), 'w')
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
                    if line[0] < line[1] and line[0] < line[2] and line[0] < line[3]:
                        tally += 1
                        array[0] += 1
                    elif line[1] < line[0] and line[1] < line[2] and line[1] < line[3]:
                        tally += 1
                        array[1] += 1
                    elif line[2] < line[0] and line[2] < line[1] and line[2] < line[3]:
                        tally += 1
                        array[2] += 1
                    elif line[3] < line[1] and line[3] < line[2] and line[3] < line[0]:
                        tally += 1
                        array[3] += 1
                tally = float(tally)
                if(tally>0):
                    first_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" +
                                        str(array[2]/tally) + "\t"+ str(array[3]/tally) + "\n"))
                else:
                    first_file.write(str(params + "\t" + str(0) + "\t" + str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))


    # works through for colonization paths
    # runs seperately for NG and Bukida starts
    path_file = open("{0}_path.txt".format(out_stem), 'w')
    for file in os.listdir(in_path):
        if fnmatch.fnmatch(file, "coltimes*.txt"):
            # input order [ng, mal, mak, buk]
            # output order NLKB, NLBK, NKLB, NKBL, NBLK, NBKL, LNKB, LNBK, LKNB, LKBN, LBNK, LBKN, KNLB, KNBL, KLNB, KLBN, KBNL, KBLN, BNLK, BNKL, BLNK, BLKN, BKNL, BKLN
            # number order 0123, 0132, 0213, 0231, 0312, 0321, 1023, 1032, 1203, 1230, 1302, 1320, 2013, 2031, 2103, 2130, 2301, 2310, 3012, 3021, 3102, 3120, 3201, 3210
            array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            fname = "{0}/{1}".format(in_path, file)
            params = file.replace("coltimes_", "").replace(".txt", "").replace("_d", "\t").replace("_", "\t")
            with open(fname) as intext:
                inlines = csv.reader(intext, delimiter='\t')
                next(inlines, None)
                tally=0
                for str_line in inlines:
                    line = [int(i) for i in str_line]
                    if line[0] < line[1] < line[2] < line[3]:
                        tally += 1
                        array[0] += 1
                    elif line[0] < line[1] < line[3] < line[2]:
                        tally += 1
                        array[1] += 1
                    elif line[0] < line[2] < line[1] < line[3]:
                        tally += 1
                        array[2] += 1
                    elif line[0] < line[2] < line[3] < line[1]:
                        tally += 1
                        array[3] += 1
                    elif line[0] < line[3] < line[1] < line[2]:
                        tally += 1
                        array[4] += 1
                    elif line[0] < line[3] < line[2] < line[1]:
                        tally += 1
                        array[5] += 1
                    elif line[1] < line[0] < line[2] < line[3]:
                        tally += 1
                        array[6] += 1
                    elif line[1] < line[0] < line[3] < line[2]:
                        tally += 1
                        array[7] += 1
                    elif line[1] < line[2] < line[0] < line[3]:
                        tally += 1
                        array[8] += 1
                    elif line[1] < line[2] < line[3] < line[0]:
                        tally += 1
                        array[9] += 1
                    elif line[1] < line[3] < line[0] < line[2]:
                        tally += 1
                        array[10] += 1
                    elif line[1] < line[3] < line[2] < line[0]:
                        tally += 1
                        array[11] += 1
                    elif line[2] < line[0] < line[1] < line[3]:
                        tally += 1
                        array[12] += 1
                    elif line[2] < line[0] < line[3] < line[1]:
                        tally += 1
                        array[13] += 1
                    elif line[2] < line[1] < line[0] < line[3]:
                        tally += 1
                        array[14] += 1
                    elif line[2] < line[1] < line[3] < line[0]:
                        tally += 1
                        array[15] += 1
                    elif line[2] < line[3] < line[0] < line[1]:
                        tally += 1
                        array[16] += 1
                    elif line[2] < line[3] < line[1] < line[0]:
                        tally += 1
                        array[17] += 1
                    elif line[3] < line[0] < line[1] < line[2]:
                        tally += 1
                        array[18] += 1
                    elif line[3] < line[0] < line[2] < line[1]:
                        tally += 1
                        array[19] += 1
                    elif line[3] < line[1] < line[0] < line[2]:
                        tally += 1
                        array[20] += 1
                    elif line[3] < line[1] < line[2] < line[0]:
                        tally += 1
                        array[21] += 1
                    elif line[3] < line[2] < line[0] < line[1]:
                        tally += 1
                        array[22] += 1
                    elif line[3] < line[2] < line[1] < line[0]:      
                        tally += 1
                        array[23] += 1
                tally = float(tally)
                if(tally>0):
                    path_file.write(str(params + "\t" + str(array[0]/tally)  + "\t" + str(array[1]/tally)  + "\t" +
                                      str(array[2]/tally)  + "\t" + str(array[3]/tally)  + "\t" +
                                      str(array[4]/tally) + "\t"+ str(array[5]/tally)  + "\t" +
                                      str(array[6]/tally)  + "\t" + str(array[7]/tally)  + "\t" +
                                      str(array[8]/tally) + "\t"+ str(array[9]/tally)  + "\t" +
                                      str(array[10]/tally)  + "\t" + str(array[11]/tally)  + "\t" +
                                      str(array[12]/tally) + "\t"+ str(array[13]/tally)  + "\t" +
                                      str(array[14]/tally)  + "\t" + str(array[15]/tally)  + "\t" +
                                      str(array[16]/tally) + "\t"+ str(array[17]/tally)  + "\t" +
                                      str(array[18]/tally)  + "\t" + str(array[19]/tally)  + "\t" +
                                      str(array[20]/tally) + "\t"+ str(array[21]/tally)  + "\t" +
                                      str(array[22]/tally)  + "\t" + str(array[23]/tally) + "\t" + str(tally) + "\n"))
                else:
                    path_file.write(str(params + "\t" + str(0) + "\t" + str(0) + "\t" + str(0) + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0)  + "\t" +
                                      str(0)  + "\t" + str(0) + "\t" + str(0) + "\n"))


if __name__ == '__main__':
    main()
            
