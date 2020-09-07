#!/bin/bash
#PBS -q batch                                                          
#PBS -N core_subppk_pirate                                       
#PBS -l nodes=1:ppn=12 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# create an alignment excluding samples with ppk duplicates
software_path="/home/rx32940/miniconda3"
pirate_path="/scratch/rx32940/pirate"

# find core genome for isolates w/o ppk gene duplication
$software_path/bin/PIRATE \
-i $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_prokka \
-o $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_pirate \
-a -r -t 12 -pan-opt "-f 6"

# module load IQ-TREE/1.6.5-omp
# iqtree -nt AUTO -m MFP -pre $pirate_path/all_dated/iqtree_all_date/iqtree_all_date_nodup_ppk -s $pirate_path/all_dated/all_dated_output/no_ppk_duplicates_alignment.fasta