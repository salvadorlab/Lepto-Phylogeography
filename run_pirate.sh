#!/bin/bash
#PBS -q batch                                                            
#PBS -N pirate_date_mi4                                        
#PBS -l nodes=1:ppn=24 -l mem=1000gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# run pirate to find the core genome of the leptospira isolates with collection date
# increase the mcl inflation value to 6 according to the software literature
/home/rx32940/miniconda3/bin/PIRATE -i /scratch/rx32940/pirate/dated_lepto -o /scratch/rx32940/pirate/dated_output_mi4 -a -r -t 12 -pan-opt "-f 6"


module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta -o SAMN02947961

# bootstrap for ML tree 1000 times confidence level
iqtree -m -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta -o SAMN02947961 -nt AUTO -B 1000