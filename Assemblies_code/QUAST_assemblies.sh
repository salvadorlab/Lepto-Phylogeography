#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N QUAST_51                                      
#PBS -l nodes=1:ppn=8 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe  

module load QUAST/5.0.2-foss-2018a-Python-2.7.14

QUASTPATH="/scratch/rx32940" 
cat $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/dated_assemblies_51.txt  | xargs -I{} quast.py \
$QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/assemblies/{}/scaffolds.fasta \
-o $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/quast_assemblies/{} \
-r $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.fna \
-g $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.gff
-t 8 

# quast.py $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/assemblies/SAMN03944914/scaffolds.fasta -o $QUASTPATH/All_Lepto_Assemblies/dated_assembled_51/quast_assemblies/SAMN03944914 \
# -r $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.fna \
# -g $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.gff \
# -t 8 
