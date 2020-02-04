#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N canu_SAMN07611463                                       
#PBS -l nodes=1:ppn=4 -l mem=200gb                                        
#PBS -l walltime=10:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

SRA_PATH="/scratch/rx32940"

module load canu/1.7-foss-2016b

canu -p lepto useGrid=false \
     -d $SRA_PATH/rest_sra_216/ecoli-pacbio/SAMN07611463 \
     genomeSize=4m -pacbio-raw \
     $SRA_PATH/rest_sra_216/SRAseq/SRR6703763.fastq.gz

