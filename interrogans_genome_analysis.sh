#!/bin/bash
#PBS -q bahl_salv_q                                                           
#PBS -N interrogans_core                                       
#PBS -l nodes=1:ppn=30 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

dir_path="/scratch/rx32940/interrogans_genome"
software_path="/home/rx32940/miniconda3"

# intra-species MCL value = 2 (default)
# to identify core-pan genome for all interrogans isolates
$software_path/bin/PIRATE \
-i $dir_path/prokka \
-o $dir_path/pirate \
-a -r -t 30 

# run snippy- generate script
# snippy_input.tab generation refer to github issue
# snippy-multi snippy_input.tab \
# --ref $dir_path/GCF_000092565.1_ASM9256v1_genomic.fna --cpus 64 > \
# run_snippy.sh

# gubbins to detect recombination
# use Kirschneri as outgroup
$software_path/run_gubbins.py --threads 64 \
-v -p $gubbins_path/gubbins/all_interrogans_gubbins \
$dir_path/snippy/clean.full.aln \
-o SAMN02947890