#!/bin/bash

# By: Ethan Gyllenhaal
# Last updated: 9 February 2022
# Shell script for running phyluce, starting with clean reads.
# Assembler used is Spades. Two .conf files are used: 

# assemble with spades
phyluce_assembly_assemblo_spades \
	--conf spades_solo.conf \
	--output spades-assemblies \
	--memory 80 \
	--cores 18

# match contigs to probes
phyluce_assembly_match_contigs_to_probes \
	--contigs spades-assemblies/contigs \
	--probes uce-5k-probes.fasta \
	--output matched_contigs &&

# get match counts
phyluce_assembly_get_match_counts \
	--locus-db matched_contigs/probe.matches.sqlite \
	--taxon-list-config solsym_uce.conf \
	--taxon-group 'all' \
	--incomplete-matrix \
	--output solsym_uce/solo_triv_incomplete.conf &&

#get fasta from match counts
phyluce_assembly_get_fastas_from_match_counts \
	--contigs spades-assemblies/contigs \
	--locus-db matched_contigs/probe.matches.sqlite \
	--match-count-output solsym_uce/solo_triv_incomplete.conf \
	--output solsym_uce/solo_triv_incomplete.fasta \
	--incomplete-matrix solo_triv.incomplete \
	--log-path logs &&

# aligning the data with mafft, errors with output as nexus
phyluce_align_seqcap_align \
	--input solsym_uce/solo_triv_incomplete.fasta \
	--output solsym_uce/mafft_aligned \
	--taxa 14 \
	--aligner mafft \
	--cores 8 \
	--output-format fasta \
	--incomplete-matrix \
	--log-path logs

# create 90% matrix
phyluce_align_get_only_loci_with_min_taxa \
	--alignments solsym_uce/mafft_aligned \
	--taxa 25 \
	--percent 0.9 \
	--output solsym_uce/mafft_90 \
	--cores 8 \
	--input-format fasta \
	--log-path logs &&

# add missing data designators
phyluce_align_add_missing_data_designators \
	--alignments solsym_uce/mafft_90 \
	--output solsym_uce/mafft_missing_90 \
	--input-format fasta \
	--output-format fasta \
	--match-count-output solsym_uce/solo_triv_incomplete.conf \
	--incomplete-matrix solo_triv.incomplete \
	--cores 8 \
	--log-path logs &&

# remove locus names from files
phyluce_align_remove_locus_name_from_files \
	--alignments solsym_uce/mafft_missing_90 \
	--output solsym_uce/mafft_missing_nolocus_nexus_90 \
	--input-format fasta \
	--output-format nexus \
	--cores 8 \
	--log-path logs &&


# get alignment summary data
phyluce_align_get_align_summary_data \
	--alignments solsym_uce/mafft_missing_nolocus_nexus_90 \
	--input-format nexus \
	--cores 8 \
	--output-stats sympos_locus_summary.csv \
	--log-path logs &&

# get phylip
phyluce_align_concatenate_alignments \
	--alignments solsym_uce/mafft_missing_nolocus_nexus_90 \
	--output solsym_uce/sympos_uce_raxml \
	--phylip \
	--log-path logs

# get nexus
phyluce_align_concatenate_alignments \
	--alignments solsym_uce/mafft_missing_nolocus_nexus_90 \
	--output solsym_uce/sympos_uce_nexus \
	--nexus \
	--log-path logs




