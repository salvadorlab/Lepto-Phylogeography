#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N mafft_interrogans_wgs                                      
#PBS -l nodes=1:ppn=32 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

module load MAFFT/7.470-GCC-8.3.0-with-extensions
software_path="/home/rx32940/miniconda3/bin"
gubbins_path="/scratch/rx32940/gubbins"
# align whole genome assemblies of interrogans 
mafft -n -1 \
$gubbins_path/dated_interrogans/fasta_dated_interrrogans/* > \
$gubbins_path/dated_interrogans/dated_interrogans_wgs.fasta

# use gubbins to find recombination regions within the genomes
# $software_path/run_gubbins.py -v