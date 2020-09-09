#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N interrogans_pirate                                       
#PBS -l nodes=1:ppn=64 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# create an alignment excluding samples with ppk duplicates
software_path="/home/rx32940/miniconda3"
pirate_path="/scratch/rx32940/pirate"

# find core genome for isolates w/o ppk gene duplication
# $software_path/bin/PIRATE \
# -i $pirate_path/interrogans_dated/interrogans_prokka \
# -o $pirate_path/interrogans_dated/interrogans_out \
# -a -r -t 64 -pan-opt "-f 6"

module load IQ-TREE/1.6.5-omp
iqtree -nt AUTO -m MFP -pre $pirate_path/interrogans_dated/iqtree_interrogans/iqtree_interrogans_core -s $pirate_path/interrogans_dated/interrogans_out/core_alignment.fasta