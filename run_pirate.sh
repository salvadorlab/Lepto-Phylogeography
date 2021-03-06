#!/bin/bash
#PBS -q batch                                                           
#PBS -N subppk_core_aa_alignment                                        
#PBS -l nodes=1:ppn=2 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe


########## Run Pirate for Core/Pan genome analysis ################################################
# run pirate to find the core genome of the leptospira isolates with collection date
# increase the mcl inflation value to 6 according to the software literature
# /home/rx32940/miniconda3/bin/PIRATE -i /scratch/rx32940/pirate/all_dated/all_dated_prokka -o /scratch/rx32940/pirate/all_dated/all_dated_output -a -r -t 12 -pan-opt "-f 6"


########## ML tree with core gene sequences alignment ##############################################
# module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
# iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/all_dated/iqtree_all_date/iqtree_all_date -s /scratch/rx32940/pirate/all_dated/all_dated_output/core_alignment.fasta

# bootstrap for ML tree 100 times confidence level
# iqtree -m GTR+F+R8 -nt AUTO -b 100 -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta 

########### call SNPs from core gene alignment #########################################################
# /home/rx32940/miniconda3/bin/snp-sites -m -v -p -b -o /scratch/rx32940/pirate/snp_sites/snp_mi6 /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta

########## ML tree with SNPs called ##############################################
# module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
# iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/iqtree_snps/iqtree_mi6_snps -s /scratch/rx32940/pirate/snp_sites/snp_mi6.phylip -o SAMN02947961


##########  AA core alignment of 95% core gene clusters  ##############################################
# 759 genes were gene clusters shared by at leatst 95% of the biosamples
# with upper threshold of avg dosage set to 1.25 
# # (1 is the perl code, but 1.25 when comparing number of core/pan genes and number of genes included in the default alignments)

software_path="/home/rx32940/miniconda3"
pirate_path="/scratch/rx32940/pirate"
# create an amino acid core genome alignment 
perl $software_path/tools/subsetting/create_pangenome_alignment_aa.pl \
-i $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_pirate/PIRATE.gene_families.tsv \
-f $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_pirate/feature_sequences \
-o $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_pirate/interrogans_core_aa_alignment.fasta \
-g $pirate_path/all_dated/all_dated_ppk/all_dated_core_nodup/all_dated_core_nodup_pirate/interrogans_core_aa_alignment.gff \
--amino-acid



########## ML tree with core gene sequences alignment ##############################################
# module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
# iqtree -nt AUTO -m MFP -pre /scratch/rx32940/pirate/all_dated/iqtree_all_date_aa/iqtree_all_date_aa -s /scratch/rx32940/pirate/all_dated/all_dated_output/core_aa_alignment_global.phy

# bootstrap for ML tree 100 times confidence level
# iqtree -m GTR+F+R8 -nt AUTO -b 100 -pre /scratch/rx32940/pirate/iqtree_mi6/iqtree_mi6 -s /scratch/rx32940/pirate/dated_output_mi6/core_alignment.fasta 
