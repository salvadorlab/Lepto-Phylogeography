#!/bin/bash

module load BEDTools/2.29.2-GCC-8.2.0-2.31.1
int_path="/scratch/rx32940/interrogans_genome"

######### Extract gene sequences from WGS fasta ######################

# 1) extract the gene info from prokka/gff files of each sample (non-hypothetical gene only)

cat $int_path/pan_genome_list.txt | 
while read gene;
do
    echo $gene
    mkdir $int_path/post_fastGear/gene_gff/$gene

    for gff in $int_path/prokka/*;
    do
        biosample=$(basename "$gff" .gff)
        echo $biosample
        cat $gff | grep "$gene" > $int_path/post_fastGear/gene_gff/$gene/$biosample.gff
        
    done

done

# 2) use bedtools getfasta to get the gene sequences from wgs fasta
#     - fasta header need to change to biosample name
# bedtools getfasta -fo post_fastGear/gene_seq/aroA1/SAMEA104369441.fasta \
# -fi assemblies/SAMEA104369441.fna \
# -bed gene_gff/aroA1/SAMEA104369441.gff
