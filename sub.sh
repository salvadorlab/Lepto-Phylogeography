#!/bin/bash
    #PBS -q highmem_q                                                            
    #PBS -N assemble_SAMN01047853                                         
    #PBS -l nodes=1:ppn=8 -l mem=200gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/rest_sra_216                        
    #PBS -e /scratch/rx32940/rest_sra_216                        
    #PBS -j oe
    
module load spades/3.12.0-k_245
python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py     -o /scratch/rx32940/rest_sra_216/assemblies/SAMN01047853     --pe1-1 /scratch/rx32940/rest_sra_216/SRAseq/SRR507753_1.fastq.gz     --pe1-2 /scratch/rx32940/rest_sra_216/SRAseq/SRR507753_2.fastq.gz
