#!/bin/bash
    #PBS -q highmem_q                                                            
    #PBS -N assemble_SAMEA104369441                                         
    #PBS -l nodes=1:ppn=4 -l mem=200gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940                        
    #PBS -e /scratch/rx32940                        
    #PBS -j oe
    
module load spades/3.12.0-k_245
python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py     -o /scratch/rx32940/picardeau/assemblies/SAMEA104369441     --pe1-1 /scratch/rx32940/picardeau/SRA_seq/ERR2192021_1.fastq.gz     --pe1-2 /scratch/rx32940/picardeau/SRA_seq/ERR2192021_2.fastq.gz
