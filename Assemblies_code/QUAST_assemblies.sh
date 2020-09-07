#!/bin/bash
#PBS -q batch                                                            
#PBS -N QUAST_all_dated                                      
#PBS -l nodes=1:ppn=12 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe  

module load QUAST/5.0.2-foss-2018a-Python-2.7.14

QUASTPATH="/scratch/rx32940/pirate/all_dated" 
cat /scratch/rx32940/pirate/dated_lepto_389.txt  | \
xargs -I{} quast.py \
$QUASTPATH/all_dated_assemblies/{}.fasta \
-o $QUASTPATH/all_dated_quast/{} \
-t 12 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14
# multiqc 
# quast.py $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/assemblies/SAMN03944914/scaffolds.fasta -o $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/quast_assemblies/SAMN03944914 \
# -r $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.fna \
# -g $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.gff \
# -t 8 
