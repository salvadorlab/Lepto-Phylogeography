#!/bin/bash
#PBS -q batch                                                            
#PBS -N pirate_date_mi4                                        
#PBS -l nodes=1:ppn=12 -l mem=50gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# run pirate to find the core genome of the leptospira isolates with collection date
# increase the mcl inflation value to 6 according to the software literature
/home/rx32940/miniconda3/bin/PIRATE -i /scratch/rx32940/pirate/dated_lepto -o /scratch/rx32940/pirate/dated_output_mi4 -a -r -t 12 -f 4