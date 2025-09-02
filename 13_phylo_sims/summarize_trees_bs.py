# script made for going through monophyly of a set of trees
# checks four sets of three taxa (out of four total)
# first calculates the number of root topologies with a given sister pair
# then calculates sister-sister distance and mean sister-outgroup distance
# outputs the proportion of each topolologies and the mean distances above
# meant to be used per-starting-location, so doesn't check for that in dictionary
# usage example: python summarize_trees.py -i 'output/trees/*support' -o test_output_v2.csv

import ete3, glob, argparse, re, pandas as pd

def main():
    # set up parser for output file
    parse = argparse.ArgumentParser(description = "Get output file")
    parse.add_argument("-o", "--output", type=str, help="Path to output file")
    parse.add_argument("-i", "--intrees", type=str, help="String for glob to interpret for trees, e.g. '/path/to/input/*tree' ")
    args = parse.parse_args()
    intrees, output = args.intrees, args.output
    
    # get all file names mathcing intrees string
    tree_names = glob.glob(intrees)
    meta_dict = {}
    for file in tree_names:
        tree = ete3.Tree(file)
        name = file.split('/')[2].split('_r')[0]
        if name not in meta_dict:
            meta_dict[name] = {'(((B,N),L),K)':0, '(((B,N),K),L)':0, '(B,N),(L,K)':0, '(((B,L),N),K)':0, '(((B,L),K),N)':0, '(B,L),(N,K)':0, '(((B,K),N),L)':0, '(((B,K),L),N)':0, '(B,K),(N,L)':0, '(((N,L),B),K)':0, '(((N,L),K),B)':0, '(((N,K),B),L)':0, '(((N,K),L),B)':0, '(((L,K),B),N)':0, '(((L,K),N),B)':0, 'Non-monophyletic':0, 'Poor-resolution':0}
            meta_dict[name]['name'] = name
            params = re.sub('\.', '', re.sub('[a-z]', '',  file)).split('_')
            meta_dict[name].update({'disp':params[1], 'ne':params[2], 'time':params[3], 'int':params[4]})
        # restrict to main taxa, set outgroup
        tree.prune(['Outgroup1','Bukida1','Bukida2','Bukida3','Bukida4','Bukida5','Bukida6',
                    'NewGeorgia1','NewGeorgia2','NewGeorgia3','NewGeorgia4','NewGeorgia5','NewGeorgia6',
                    'Malaita1','Malaita2','Malaita3','Malaita4','Malaita5','Malaita6',
                    'Makira1','Makira2','Makira3','Makira4','Makira5','Makira6'])
        tree.set_outgroup("Outgroup1")
        if check_mono(tree):
            tree.prune(['Outgroup1','Bukida1','NewGeorgia1','Malaita1','Makira1'])
            meta_dict[name][get_topology(tree)]+=1
        else:
            meta_dict[name]['Non-monophyletic']+=1
    #outfile = open(output, 'w')
    #print(meta_dict)
    df = pd.DataFrame(meta_dict)
    df.transpose().to_csv(output)

def check_mono(tree):
    #print(tree)
    if tree.check_monophyly(['Bukida1','Bukida2','Bukida3','Bukida4','Bukida5','Bukida6'], target_attr="name")[0] & \
       tree.check_monophyly(['NewGeorgia1','NewGeorgia2','NewGeorgia3','NewGeorgia4','NewGeorgia5','NewGeorgia6'], target_attr="name")[0] & \
       tree.check_monophyly(['Malaita1','Malaita2','Malaita3','Malaita4','Malaita5','Malaita6'], target_attr="name")[0] & \
       tree.check_monophyly(['Makira1','Makira2','Makira3','Makira4','Makira5','Makira6'], target_attr="name")[0]:
        return True
    else:
        return False

def get_topology(tree):
    buk = ['Bukida1']
    ng = ['NewGeorgia1']
    mal = ['Malaita1']
    mak = ['Makira1']
    min_support=100.0
    for node in tree.traverse():
        # Support greater than 1.0 is to ignore leaves
        if(node.support<min_support and node.support>1.0): 
            min_support=node.support
    if min_support<70.0:
        return("Poor-resolution")
    elif tree.check_monophyly(buk + ng, target_attr="name")[0]:
        if tree.check_monophyly(buk + ng + mal, target_attr="name")[0]:
            return("(((B,N),L),K)")
        elif tree.check_monophyly(buk + ng + mak, target_attr="name")[0]:
            return("(((B,N),K),L)")
        else:
            return("(B,N),(L,K)")
    elif tree.check_monophyly(buk + mal, target_attr="name")[0]:
        if tree.check_monophyly(buk + mal + ng, target_attr="name")[0]:
            return("(((B,L),N),K)")
        elif tree.check_monophyly(buk + mal + mak, target_attr="name")[0]:
            return("(((B,L),K),N)")
        else:
            return("(B,L),(N,K)")
    elif tree.check_monophyly(buk + mak, target_attr="name")[0]:
        if tree.check_monophyly(buk + mak + ng, target_attr="name")[0]:
            return("(((B,K),N),L)")
        elif tree.check_monophyly(buk + mak + mal, target_attr="name")[0]:
            return("(((B,K),L),N)")
        else:
            return("(B,K),(N,L)")
    elif tree.check_monophyly(ng + mal, target_attr="name")[0]:
        if tree.check_monophyly(ng + mal + buk, target_attr="name")[0]:
            return("(((N,L),B),K)")
        elif tree.check_monophyly(ng + mal + mak, target_attr="name")[0]:
            return("(((N,L),K),B)")
        else:
            return("(B,K),(N,L)")
    elif tree.check_monophyly(ng + mak, target_attr="name")[0]:
        if tree.check_monophyly(ng + mak + buk, target_attr="name")[0]:
            return("(((N,K),B),L)")
        elif tree.check_monophyly(ng + mak + mal, target_attr="name")[0]:
            return("(((N,K),L),B)")
        else:
            return("(B,L),(N,K)")
    elif tree.check_monophyly(mal + mak, target_attr="name")[0]:
        if tree.check_monophyly(mal + mak + buk, target_attr="name")[0]:
            return("(((L,K),B),N)")
        elif tree.check_monophyly(mal + mak + ng, target_attr="name")[0]:
            return("(((L,K),N),B)")
        else:
            return("(B,N),(L,K)")
    else:
        return("hmm")
    return("hmm")


if __name__ == '__main__':
    main()
