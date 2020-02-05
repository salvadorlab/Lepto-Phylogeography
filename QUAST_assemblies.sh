#!/bin/bash
#PBS -q bahl_salv_q                                                            
#PBS -N QUAST                                        
#PBS -l nodes=1:ppn=8 -l mem=100gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe  

module load QUAST/5.0.2-foss-2018a-Python-2.7.14

QUASTPATH="/scratch/rx32940" 
cat $QUASTPATH/All_Lepto_Assemblies/PATRIC_assemblies_633/PATRIC_biosample_633.txt | xargs -I{} quast.py \
$QUASTPATH/All_Lepto_Assemblies/PATRIC_assemblies_633/ncbi-genomes-2020-01-22/{}.fna.gz \
-o $QUASTPATH/All_Lepto_Assemblies/PATRIC_assemblies_633/quast_assemblies/{} \
-r $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.fna \
-g $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.gff
-t 8 

# quast.py $QUASTPATH/assembled_51/SAMN13046976/scaffolds.fasta -o $QUASTPATH/quast_assemblies/SAMN13046976 \
# -r $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.fna \
# -g $QUASTPATH/reference/GCF_000092565.1_ASM9256v1_genomic.gff
# -t 8 
