#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N mafft_interrogans_wgs                                      
#PBS -l nodes=1:ppn=32 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

module load MAFFT/7.470-GCC-8.3.0-with-extensions
module load snippy/4.4.1-foss-2018b-Perl-5.28.0
module load SAMtools/1.9-foss-2016b
module load BCFtools/1.9-foss-2016b

software_path="/home/rx32940/miniconda3/bin"
gubbins_path="/scratch/rx32940/gubbins"
# usee snippy to produce bacterial wgs msa
# 1) To Create tab file for multi-snippy
# # To save filenames as ID
# ls > ../file1.txt
# # To save filenames with their paths as contigs
# ls $(pwd)/* > ../file2.txt
# # To combine both files columnwise and have tabs
# paste ../file1.txt ../file2.txt > ../snippy_input.tab
# samtools has to downgraded to 1.9: ```conda install -c bioconda samtools=1.9```
# 2) use snippy-multi to generate script to run snippy with multi-samples \
# and create core snps alignments with all samples core.full.aln
# snippy-multi snippy_input.tab --ref GCF_000092565.1_ASM9256v1_genomic.fna --cpus 12 > run_snippy.sh
# 3) output folders will be in working dir, thus add cd $wd to the beginning of run_snippy
# 4) bash run_snippy.sh


mafft -n -1 \
$gubbins_path/dated_interrogans/fasta_dated_interrrogans/* > \
$gubbins_path/dated_interrogans/dated_interrogans_wgs.fasta

# use gubbins to find recombination regions within the genomes
# $software_path/run_gubbins.py -v