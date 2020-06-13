#!/bin/bash
#PBS -q bahl_salv_q                                                            
#PBS -N COG_analysis                                    
#PBS -l nodes=1:ppn=48
#PBS -l mem=30gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

cd /scratch/rx32940/get_homo/

ml GETHOMOLOGUES/1.7.6

# default aglorithm doesn't have -t 0 option available (see manual section 4.8)

# use COG algorithm with all possible clusters (even thus which might not contain sequences from all input genomes (taxa))
# used -o for blast search only, delete -o for orthologous genes clustering after blast
get_homologues.pl -d /scratch/rx32940/get_homo/gbk -t 0 -G -n 48
# use OMCL algorithm with all possible clusters
# get_homologues.pl -d /scratch/rx32940/get_homo/gbk_dup -t 0 -M -n 48 -o
