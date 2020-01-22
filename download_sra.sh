#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N lepto_fastq                                            
#PBS -l nodes=1:ppn=8 -l mem=300gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe     

cd $PBS_O_WORKDIR

module load SRA-Toolkit/2.9.1-centos_linux64

cat /scratch/rx32940/picardeau/picardeau_313_sra.txt | xargs -I{} fastq-dump --gzip --split-files -O /scratch/rx32940/picardeau/SRA_seq {}

#fastq-dump --gzip --split-files -O /scratch/rx32940/ SRR10301832