#!/bin/bash
    #PBS -q batch                                                            
    #PBS -N assemble_ERR027313                                         
    #PBS -l nodes=1:ppn=8 -l mem=100gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/rest_sra_216                        
    #PBS -e /scratch/rx32940/rest_sra_216                        
    #PBS -j oe
    
module load spades/3.12.0-k_245
python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py     -o /scratch/rx32940/rest_sra_216/assemblies/ERR027313     --pe1-1 /scratch/rx32940/rest_sra_216/SRAseq/ERR027313_1.fastq.gz     --pe1-2 /scratch/rx32940/rest_sra_216/SRAseq/ERR027313_4.fastq.gz
