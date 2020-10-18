#!/bin/bash
#PBS -q batch                                                          
#PBS -N prot_cluster                                      
#PBS -l nodes=1:ppn=1 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

ml Anaconda3/2019.07
ml prodigal/2.6.3-GCCcore-8.3.0

script_path="/home/rx32940/github/Lepto-Phylogeography"
Rscript $script_path/interrogans_dated_micropan.r > /scratch/rx32940/pirate/interrogans_dated/micropan_interrogans/prot_cluster.log