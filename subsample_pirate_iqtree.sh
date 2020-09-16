#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N interrogans_iqtree                                      
#PBS -l nodes=1:ppn=64 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

# create an alignment excluding samples with ppk duplicates
software_path="/home/rx32940/miniconda3"
pirate_path="/scratch/rx32940/pirate"

# find core genome for isolates w/o ppk gene duplication
# $software_path/bin/PIRATE \
# -i $pirate_path/interrogans_dated/interrogans_prokka \
# -o $pirate_path/interrogans_dated/interrogans_out \
# -a -r -t 64 -pan-opt "-f 6"

# create an amino acid core genome alignment 
# amino acid sequences has line breaks within each gene,
# line breaks were removed by the code underneath and stored in the core_feature_sequences dir:
# cat ../core_gene_interrogans_3123.txt | for file in ./*; do gene=$(basename "$file" ".aa.fasta"); awk '!/^>/ { printf "%s", $0; n = "\n" } 
# /^>/ { print n $0; n = "" }
# END { printf "%s", n }
# ' $gene.aa.fasta > $gene.aa2.fasta;
# done

perl $software_path/tools/subsetting/create_pangenome_alignment_aa.pl --amino-acid \
-i $pirate_path/interrogans_dated/interrogans_out/PIRATE.core_gene_families.ordered.tsv \
-f $pirate_path/interrogans_dated/interrogans_out/core_feature_sequences \
-o $pirate_path/interrogans_dated/interrogans_out/interrogans_core_aa_alignment.fasta \
-g $pirate_path/interrogans_dated/interrogans_out/interrogans_core_aa_alignment.gff 

module load IQ-TREE/1.6.5-omp
iqtree -nt AUTO -m MFP -pre $pirate_path/interrogans_dated/iqtree_interrogans/iqtree_interrogans \
-s $pirate_path/interrogans_dated/interrogans_out/core_alignment.fasta