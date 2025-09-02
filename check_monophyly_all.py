# script made for going through monophyly of a set of trees
# checks four sets of three taxa (out of four total)
# first calculates the number of root topologies with a given sister pair
# then calculates sister-sister distance and mean sister-outgroup distance
# outputs the proportion of each topolologies and the mean distances above

import ete3, glob

# name globals, taxon names used to make gene trees
buk = 'S_barbatus_32025'
mak = 'S_vidua_35062'
ng = 'S_browni_36125'
mal = 'S_barbatus_32735'
og = 'S_verticalis_27841'

def main():
    all_stats()

def all_stats():
    # number of trees with given topology, X sister means X is sister to clade of other taxa
    B_sister = 0
    N_sister = 0
    L_sister = 0
    K_sister = 0
    BN_bal = 0
    other = 0
    # mean distance between clade excluding X for above comparisons (not for balanced topologies)
    B_sis_dist = 0
    N_sis_dist = 0
    L_sis_dist = 0
    K_sis_dist = 0
    #BN_bal = 0 #BL_bal = 0 #BK_bal = 0
    BN_sis_dist = 0
    LK_sis_dist = 0
    # mean distance from an individual to the outgroup
    B_dist = 0
    N_dist = 0
    L_dist = 0
    K_dist = 0
    BN_bal_dist = 0
    #other_dist = 0
    # overall counter
    total = 0
    # get list of trees
    # NOTE: this is set for 2 PIS, but has to be manually changed
    names = glob.glob('all_PIS2/*treefile')
    for file in names:
        total += 1 # increment total
        gt = ete3.Tree(file) # read in tree
        gt.set_outgroup(og) # root
        # checks for Bukida sister pattern
        if gt.check_monophyly([ng,mal,mak], target_attr="name")[0]:
            B_sister = B_sister + 1
            B_sis_dist += ((gt.get_distance(ng,mal) + gt.get_distance(ng,mak) + gt.get_distance(mal,mak))/3)
            B_dist += ((gt.get_distance(ng,buk) + gt.get_distance(mal,buk) + gt.get_distance(mak,buk))/3)
        # New Georgia sister
        elif gt.check_monophyly([buk,mal,mak], target_attr="name")[0]:
            N_sister = N_sister + 1
            N_sis_dist += ((gt.get_distance(buk,mal) + gt.get_distance(buk,mak) + gt.get_distance(mal,mak))/3)
            N_dist += ((gt.get_distance(buk,ng) + gt.get_distance(mal,ng) + gt.get_distance(mak,ng))/3)
        # Malaita sister
        elif gt.check_monophyly([buk,ng,mak], target_attr="name")[0]:
            L_sister = L_sister + 1
            L_sis_dist += ((gt.get_distance(buk,ng) + gt.get_distance(buk,mak) + gt.get_distance(ng,mak))/3)
            L_dist += ((gt.get_distance(buk,mal) + gt.get_distance(ng,mal) + gt.get_distance(mak,mal))/3)
        # Makira sister
        elif gt.check_monophyly([buk,ng,mal], target_attr="name")[0]:
            K_sister = K_sister + 1
            K_sis_dist += ((gt.get_distance(buk,ng) + gt.get_distance(buk,mal) + gt.get_distance(ng,mak))/3)
            K_dist += ((gt.get_distance(buk,mak) + gt.get_distance(ng,mak) + gt.get_distance(mal,mak))/3)
        # Balanced topology
        elif gt.check_monophyly([buk,ng], target_attr="name")[0] and gt.check_monophyly([mal,mak], target_attr="name")[0]:
            BN_bal = BN_bal + 1
            BN_sis_dist += (gt.get_distance(buk,ng))
            LK_sis_dist += (gt.get_distance(mal,mak))
            BN_bal_dist += ((gt.get_distance(buk,mal) + gt.get_distance(buk,mak) + gt.get_distance(ng,mal) + gt.get_distance(ng,mak))/4)
        else:
            other += 1
    # print results
    print("All Results, sister order is B, N, L, K, BN balance, and other", total)
    print(B_sister/total, N_sister/total, L_sister/total, K_sister/total, BN_bal/total, other/total)
    print(B_sis_dist/B_sister, N_sis_dist/N_sister, L_sis_dist/L_sister, K_sis_dist/K_sister, BN_sis_dist/BN_bal, LK_sis_dist/BN_bal)
    print(B_dist/B_sister, N_dist/N_sister, L_dist/L_sister, K_dist/K_sister, BN_bal_dist/BN_bal)

if __name__ == '__main__':
    main()
