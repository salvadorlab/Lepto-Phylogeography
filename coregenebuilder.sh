#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N core_gene_builder                                        
#PBS -l nodes=1:ppn=8 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe 

module load prokka/1.13-foss-2016b-BioPerl-1.7.1

PROKKAPATH="/scratch/rx32940/"
cat $PROKKAPATH/assembled.txt | xargs -I{} prokka --kingdom Bacteria --outdir $PROKKAPATH/prokka_output/{} --genus Leptospira --locustag {} /scratch/rx32940/assembled_51/{}/scaffolds.fasta

