#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_SAMN13046976                                         
#PBS -l nodes=1:ppn=4 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe     

module load spades/3.12.0-k_245 

SRA_PATH="/scratch/rx32940/"
cat $SRA_PATH/picardeau/picardeau_313_sra.txt | xargs - I python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
-o $SRA_PATH/picardeau/assemblies/{} \
--pe1-1 $SRA_PATH/picardeau/SRA_seq/{}_1.fastq.gz
--pe1-2 $SRA_PATH/picardeau/SRA_seq/{}_2.fastq.gz

