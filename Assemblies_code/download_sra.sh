#!/bin/bash
#PBS -q bahl_salv_q                                                           
#PBS -N download                                            
#PBS -l nodes=1:ppn=4 -l mem=30gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe     

cd $PBS_O_WORKDIR

module load SRA-Toolkit/2.9.1-centos_linux64

# cat /scratch/rx32940/rest_sra_216/rest_sra_216.txt | xargs -I{} fastq-dump --gzip --split-files -O /scratch/rx32940/rest_sra_216/SRAseq {}

fastq-dump --gzip --split-files -O /scratch/rx32940/rest_sra_216/PRJEB36553_4 ERR4056312

#fastq-dump --gzip --split-files -O /scratch/rx32940/ SRR10301832

# SRA_PATH="/scratch/rx32940"

