#!/bin/bash
#PBS -q batch                                                            
#PBS -N iqtree_snp_mfp                                        
#PBS -l nodes=1:ppn=16 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe


########## Run Pirate for Core/Pan genome analysis ################################################
# run pirate to find the core genome of the leptospira isolates with collection date
# increase the mcl inflation value to 6 according to the software literature
# /home/rx32940/miniconda3/bin/PIRATE -i /scratch/rx32940/pirate/dated_lepto -o /scratch/rx32940/pirate/dated_output_mi4 -a -r -t 12 -pan-opt "-f 6"


########## ML tree with core gene sequences alignment ##############################################
# module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
# iqtree -nt 64 -m MFP -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta -o SAMN02947961

# bootstrap for ML tree 1000 times confidence level
# iqtree -m -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta -o SAMN02947961 -nt AUTO -B 1000

########### call SNPs from core gene alignment #########################################################
# /home/rx32940/miniconda3/bin/snp-sites -m -v -p -b -o /scratch/rx32940/pirate/snp_sites/snp_mi6 /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta

########## ML tree with SNPs called ##############################################
module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/iqtree_snps/iqtree_mi6_snps -s /scratch/rx32940/pirate/snp_sites/snp_mi6.phylip -o SAMN02947961
