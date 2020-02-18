#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N dated51_pipeline                                        
#PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

###################################################################
#
# fastq files with runs (technical replicates) merged into one
# quality check
#
####################################################################

# path_51="/scratch/rx32940/merged_runs"
# path_qc="/scratch/rx32940/Lepto_Work/fastqc/" 

# module load FastQC/0.11.8-Java-1.8.0_144

# all_files=$(ls -d "$path_51"/*) # list absolute path of all files in the dir

# fastqc -t 12 -o fastqc -o $path_qc -f fastq $all_files # do fastqc for all 51 at once

######################################################################
#
# multiqc
# Aggregate all fastqc reports for the 51 biosamples with collection date 
#
# #####################################################################

path_qc="/scratch/rx32940/Lepto_Work/fastqc" 

module load MultiQC/1.5-foss-2016b-Python-2.7.14

multiqc $path_qc/*_fastqc.zip -o $path_qc

