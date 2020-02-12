#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N mummerplot                                        
#PBS -l nodes=1:ppn=2 -l mem=30gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe 

module load MUMmer/4.0.0beta2-foss-2016b

ref_path="/scratch/rx32940"
gunzip $ref_path/All_Lepto_Assemblies/PATRIC_assemblies_633/assemblies/SAMN12871448.fna.gz
nucmer $ref_path/reference/GCF_000092565.1_ASM9256v1_genomic.fna $ref_path/All_Lepto_Assemblies/PATRIC_assemblies_633/assemblies/SAMN12871448.fna -p $ref_path/SAMN12871448
delta-filter -1 $ref_path/SAMN12871448.delta
mummerplot --size large -fat --color -f --png $ref_path/SAMN12871448.delta -p $ref_path/SAMN12871448