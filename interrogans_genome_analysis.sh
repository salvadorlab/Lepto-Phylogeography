#!/bin/bash
#PBS -q bahl_salv_q                                                           
#PBS -N test_fastGear_gene                                       
#PBS -l nodes=1:ppn=60 -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

dir_path="/scratch/rx32940/interrogans_genome"
software_path="/home/rx32940/miniconda3"
fastGear_path="/home/rx32940/fastGEARpackageLinux64bit"
matlab_path="/home/rx32940/MATLAB/v901" 
file_path="/scratch/rx32940/interrogans_genome/pirate/feature_sequences"

LD_LIBRARY_PATH=/home/rx32940/MATLAB/v901/runtime/glnxa64:/home/rx32940/MATLAB/v901/bin/glnxa64:/home/rx32940/MATLAB/v901/sys/os/glnxa64:/home/rx32940/MATLAB/v901/sys/opengl/lib/glnxa64

# intra-species MCL value = 2 (default)
# to identify core-pan genome for all interrogans isolates
# $software_path/bin/PIRATE \
# -i $dir_path/prokka \
# -o $dir_path/pirate \
# -a -r -t 30 

# # after filtered genes base on : https://github.com/salvadorlab/Lepto-Phylogeography/issues/6#issuecomment-705812907
# # run fastGear on filtered conservative genes
# $fastGear_path/run_fastGEAR.sh $matlab_path \
# $file_path/g00295_1.nucleotide.fasta \
# $dir_path/fastGear/interrogans_g00295.mat \
# $fastGear_path/fG_input_specs.txt

# # plot base on original sample order
# $fastGear_path/run_plotRecombinations.sh $matlab_path $dir_path/fastGear/interrogans_g00295.mat 1 1

# run snippy- generate script
# snippy_input.tab generation refer to github issue
# snippy-multi snippy_input.tab \
# --ref $dir_path/GCF_000092565.1_ASM9256v1_genomic.fna --cpus 64 > \
# run_snippy.sh

# # remove all the "weird" characters and replace them with N
# snippy-clean_full_aln core.full.aln > clean.full.aln

# gubbins to detect recombination
# use Kirschneri as outgroup
$software_path/run_gubbins.py --threads 60 \
-v -p $gubbins_path/gubbins/all_interrogans_gubbins \
$dir_path/snippy/clean.full.aln \
-o SAMN02947890