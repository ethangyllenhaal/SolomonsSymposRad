#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 9 February 2022
# Wrapper shell script for all DSuite functions.
# First line per section makes the Dtrios ABBA/BABA output, then Fbranch is calculated, the Fbranch is plotted, and finally files are renamed.

# Full dataset (used for main ABBA/BABA)
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_main -o full/main -k 50 -t topo.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_main.nwk full/main_tree.txt -p 0.05 > fbranch_main.txt
/path/to/Dsuite/utils/dtools.py fbranch_main.txt topo.nwk
mv fbranch.png fbranch_main.png
mv fbranch.svg frabnch_main.svg

# Malaita excluded
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_noMal -o full/noMal -k 50 -t topo_noMal.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_noMal.nwk full/noMal_tree.txt -p 0.05 > fbranch_noMal.txt
/path/to/Dsuite/utils/dtools.py fbranch_noMal.txt topo_noMal.nwk
mv fbranch.png fbranch_noMal.png
mv fbranch.svg fbranch_noMal.svg

# Phylogenetically uncertain taxa removed
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_conservative -o full/conservative -k 50 -t topo_conservative.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_conservative.nwk full/conservative_tree.txt -p 0.05 > fbranch_conservative.txt
/path/to/Dsuite/utils/dtools.py fbranch_conservative.txt topo_conservative.nwk
mv fbranch.png fbranch_conservative.png
mv fbranch.svg fbranch_conservative.svg

# Phylogenetically uncertain taxa and Malaita removed
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_conservative_noMal -o full/conservative_noMal -k 50 -t topo_conservative_noMal.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_conservative_noMal.nwk full/conservative_noMal_tree.txt -p 0.05 > fbranch_conservative_noMal.txt
/path/to/Dsuite/utils/dtools.py fbranch_conservative_noMal.txt topo_conservative_noMal.nwk
mv fbranch.png fbranch_conservative_noMal.png
mv fbranch.svg fbranch_conservative_noMal.svg

# New Georgia excluded
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_malbar -o full/malbar -k 50 -t topo_malbar.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_malbar.nwk full/malbar_tree.txt -p 0.05 > fbranch_malbar.txt
/path/to/Dsuite/utils/dtools.py fbranch_malbar.txt topo_malbar.nwk
mv fbranch.png fbranch_malbar.png
mv fbranch.svg fbranch_malbar.svg

# New Georgia and uncertain taxa excluded
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_malbar_conservative -o full/malbar_conservative -k 50 -t topo_malbar_conservative.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_malbar_conservative.nwk full/malbar_conservative_tree.txt -p 0.05 > fbranch_malbar_conservative.txt
/path/to/Dsuite/utils/dtools.py fbranch_malbar_conservative.txt topo_malbar_conservative.nwk
mv fbranch.png fbranch_malbar_conservative.png
mv fbranch.svg fbranch_malbar_conservative.svg

# Full dataset randomly downsampled to a maximum of three individuals
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_downsample3 -o full/downsample3 -k 50 -t topo.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_main.nwk full/downsample3_tree.txt -p 0.05 > fbranch_downsample3.txt
/path/to/Dsuite/utils/dtools.py fbranch_downsample3.txt topo_main.nwk
mv fbranch.png fbranch_downsample3.png
mv fbranch.svg frabnch_downsample3.svg

# Full dataset randomly downsampled to a maximum of two individuals
/path/to/Dsuite/Build/Dsuite Dtrios full_75.vcf map_downsample2 -o full/downsample2 -k 50 -t topo.nwk
/path/to/Dsuite/Build/Dsuite Fbranch topo_main.nwk full/downsample2_tree.txt -p 0.05 > fbranch_downsample2.txt
/path/to/Dsuite/utils/dtools.py fbranch_downsample2.txt topo_main.nwk
mv fbranch.png fbranch_downsample2.png
mv fbranch.svg frabnch_downsample2.svg
