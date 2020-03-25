#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_SAMEA864115                                         
#PBS -l nodes=1:ppn=8 -l mem=200gb                                        
#PBS -l walltime=10:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940/rest_sra_216                        
#PBS -e /scratch/rx32940/rest_sra_216                        
#PBS -j oe

SRA_PATH="/scratch/rx32940"

module load spades/3.12.0-k_245

python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    -o $SRA_PATH/rest_sra_216/assemblies/SAMEA864115 \
    --pe1-1 $SRA_PATH/rest_sra_216/SRAseq/ERR017118_1.fastq.gz \
    --pe1-2 $SRA_PATH/rest_sra_216/SRAseq/ERR017118_3.fastq.gz
