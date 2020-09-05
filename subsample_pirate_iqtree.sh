#!/bin/bash
#PBS -q batch                                                           
#PBS -N subppk_core_iqtree                                       
#PBS -l nodes=1:ppn=3 -l mem=80gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# create an alignment excluding samples with ppk duplicates
# software_path="/home/rx32940/miniconda3"
# pirate_path="/scratch/rx32940/pirate"
# $software_path/scripts/create_pangenome_alignment.pl \
# -l $pirate_path/all_dated/all_dated_output/genome_no_ppk_duplicates.txt \
# -i $pirate_path/all_dated/all_dated_output/PIRATE.gene_families.tsv \
# -f $pirate_path/all_dated/all_dated_output/feature_sequences/ \
# -o $pirate_path/all_dated/all_dated_output/no_ppk_duplicates_alignment.fasta \
# -g $pirate_path/all_dated/all_dated_output/no_ppk_duplicates_alignment.gff

iqtree -nt AUTO -m MFP -pre $pirate_path/all_dated/iqtree_all_date/iqtree_all_date_subsample_ppk -s $pirate_path/all_dated/all_dated_output/no_ppk_replicates_alignment.fasta