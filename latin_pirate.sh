#!/bin/bash
#PBS -q batch                                                            
#PBS -N latin_iqtree                                        
#PBS -l nodes=1:ppn=24 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe


########## Run Pirate for Core/Pan genome analysis ################################################
# run pirate to find the core genome of the leptospira isolates with collection date
# increase the mcl inflation value to 6 according to the software literature
# /home/rx32940/miniconda3/bin/PIRATE -i /scratch/rx32940/pirate/latin_lepto/latin_prokka -o /scratch/rx32940/pirate/latin_lepto/latin_output/ -a -r -t 12 -pan-opt "-f 6"


########## ML tree with core gene sequences alignment ##############################################
module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/latin_lepto/iqtree_latin/iqtree_latin -s /scratch/rx32940/pirate/latin_lepto/latin_output/core_alignment.fasta