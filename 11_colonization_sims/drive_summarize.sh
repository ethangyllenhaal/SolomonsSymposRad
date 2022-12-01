#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 7 November 2022
# Shell script for modifying and summarizing output from colonization simulations

# Replaces -1 with 99999, i.e. islands never colonized get a colonization time later than is possible
sed -i 's/-1/99999/g' output_mod/*
# Runs python script
python summarize_output.py -i output_mod -o output_mod/summarized
