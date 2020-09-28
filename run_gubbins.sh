#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N interrogans_gubbins                                      
#PBS -l nodes=1:ppn=64 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

software_path="/home/rx32940/miniconda3/bin"
gubbins_path="/scratch/rx32940/gubbins/dated_interrogans"

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
# 5) moved all output dir to snippy_out
# 6) snippy-clean_full_aln core.full.aln > clean.full.aln

# use gubbins to find recombination regions within the genomes
$software_path/run_gubbins.py --threads 64 -v -p $gubbins_path/gubbins_out/dated_interrogans_gubbins $gubbins_path/snippy_out/clean.full.aln