#!/bin/bash
#PBS -q batch                                                            
#PBS -N ppk_iqtree                                    
#PBS -l nodes=1:ppn=24 -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

fasta_path="/scratch/rx32940/pirate/all_dated/all_dated_assemblies"
gff_path="/scratch/rx32940/pirate/all_dated/all_dated_prokka"
out_path="/scratch/rx32940/pirate/all_dated/all_dated_ppk"

module load BEDTools/2.29.2-GCC-8.2.0-2.31.1
module load SAMtools/1.10-GCC-8.2.0-2.31.1



# # create ppk gene gff3 file for each isolate
# for gff in $gff_path/*;
# do
# SAMN=$(basename $gff ".gff")
# cat $gff | grep "ppk" > $out_path/ppk_gff/${SAMN}_ppk.gff
# done

# # rename ncbi downloaded assemblies *.fna file to *.fasta
# rename .fna .fasta *.fna

# # index input fasta file of the assemblies of the isolates
# for fasta in $fasta_path/*.fasta;
# do
# samtools faidx $fasta;
# done

# # get ppk gene sequence for each isolate
# for gff in $out_path/ppk_gff/*;
# do
# SAMN=$(basename $gff "_ppk.gff") 
# bedtools getfasta -fo $out_path/ppk_fasta/${SAMN}_ppk.fasta \
# -name -fi $fasta_path/$SAMN.fasta -bed $gff
# done

# merge all ppk gene fasta files into a multifasta
# 1) rename the header of each fasta
# for fasta in $out_path/ppk_fasta/*;
# do
# SAMN=$(basename $fasta "_ppk.fasta")
# # replace the line with the pattern starting with ">" by ">"and the biosample id 
# sed -i "s/^\(>.*\)/>$SAMN/" $fasta;
# done

# 2) combine fasta file into a multi-fasta file
# cat $out_path/ppk_fasta/*_ppk.fasta > $out_path/ppk_all_date.fasta 

# create multisequence alignment for all dated isolates' ppk gene sequences
# module load MAFFT/7.470-GCC-8.3.0-with-extensions
# mafft --thread 12 --maxiterate 1000 --globalpair --nuc $out_path/ppk_all_date.fasta > $out_path/ppk_all_dated_alignment.fasta

# # generate ppk ML tree
module load IQ-TREE/1.6.5-omp
iqtree -nt AUTO -m MFP -pre $out_path/ppk_iqtree/ppk_iqtree -s $out_path/ppk_all_dated_alignment.fasta 


