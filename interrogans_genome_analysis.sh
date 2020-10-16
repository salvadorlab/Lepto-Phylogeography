#!/bin/bash
## PBS -N all_int_iqtree                                      
## PBS -l nodes=1:ppn=64 -l mem=100gb                                        
## PBS -l walltime=200:00:00                                                
## PBS -M rx32940@uga.edu                                                  
## PBS -m abe                                                              
## PBS -o /scratch/rx32940                        
## PBS -e /scratch/rx32940                        
## PBS -j oe

dir_path="/scratch/rx32940/interrogans_genome"
software_path="/home/rx32940/miniconda3"
fastGear_path="/home/rx32940/fastGEARpackageLinux64bit"
matlab_path="/home/rx32940/MATLAB/v901" 
file_path="/scratch/rx32940/interrogans_genome/pirate/feature_sequences"

# LD_LIBRARY_PATH=/home/rx32940/MATLAB/v901/runtime/glnxa64:/home/rx32940/MATLAB/v901/bin/glnxa64:/home/rx32940/MATLAB/v901/sys/os/glnxa64:/home/rx32940/MATLAB/v901/sys/opengl/lib/glnxa64

# intra-species MCL value = 2 (default)
# to identify core-pan genome for all interrogans isolates
# $software_path/bin/PIRATE \
# -i $dir_path/prokka \
# -o $dir_path/pirate \
# -a -r -t 30 

# # parse PIRATE outputs 
# perl PIRATE_to_roary.pl -i /scratch/rx32940/interrogans_genome/pirate/PIRATE.*.tsv -o /scratch/rx32940/interrogans_genome/pirate/roary_presence_absence

# # recontruct the ML tree with core genome concatenation produced by PIRATE
# # this will be used in python code for plot fastGear results
module load IQ-TREE/1.6.5-omp
iqtree -nt AUTO -m MFP -pre $dir_path/iqtree/all_int_core \
-s $dir_path/pirate/core_alignment.fasta

# after filtered genes base on : https://github.com/salvadorlab/Lepto-Phylogeography/issues/6#issuecomment-705812907
# run fastGear on filtered conservative genes
# splited the 8135 genes with avg dosage <= 1.25 in to 41 files with 200 gene id per file
# split -l 200 pan_genome_list.txt 
# mkdir folders for each gene in the fastGear folder

    
# script_path="dir_path=\"/scratch/rx32940/interrogans_genome\"\n
# software_path=\"/home/rx32940/miniconda3\"\n
# fastGear_path=\"/home/rx32940/fastGEARpackageLinux64bit\"\n
# matlab_path=\"/home/rx32940/MATLAB/v901\"\n
# file_path=\"/scratch/rx32940/interrogans_genome/pirate/feature_sequences\"\n
# LD_LIBRARY_PATH=/home/rx32940/MATLAB/v901/runtime/glnxa64:/home/rx32940/MATLAB/v901/bin/glnxa64:/home/rx32940/MATLAB/v901/sys/os/glnxa64:/home/rx32940/MATLAB/v901/sys/opengl/lib/glnxa64\n"
    
# for list in $dir_path/x*;
# do
#     echo "create script for $list"
#     (
#     echo -e 
#     job_header="#!/bin/bash\n
#     #PBS -q batch\n
#     #PBS -N ${list}_fastGear\n
#     #PBS -l nodes=1:ppn=1 -l mem=30gb\n
#     #PBS -l walltime=200:00:00\n
#     #PBS -M rx32940@uga.edu\n
#     #PBS -m abe\n
#     #PBS -o /scratch/rx32940\n
#     #PBS -e /scratch/rx32940\n
#     #PBS -j oe\n"

#     echo -e "$job_header" > $dir_path/submit_sub_fastGear.sh

#     echo -e "$script_path" >> $dir_path/submit_sub_fastGear.sh

#     echo -e "cat $list | xargs -I{} \
#     $fastGear_path/run_fastGEAR.sh $matlab_path \
#     $file_path/{}.nucleotide.fasta \
#     $dir_path/fastGear/{}/interrogans_{}.mat \
#     $fastGear_path/fG_input_specs.txt" >> $dir_path/submit_sub_fastGear.sh

#     qsub $dir_path/submit_sub_fastGear.sh
    
#     echo -e "submitted script for $list"
#     ) &
#     echo "waiting"
#     wait
# done

# # # plot scatterplot for all genes in pan genome
# python post_fastGEAR.py \
# -i $dir_path/fastGear/ \
# -o $dir_path/fastGear_out/all_int_recomb \
# -s -f pdf -z False 

# run snippy- generate script
# snippy_input.tab generation refer to github issue
# snippy-multi snippy_input.tab \
# --ref $dir_path/GCF_000092565.1_ASM9256v1_genomic.fna --cpus 64 > \
# run_snippy.sh

# # remove all the "weird" characters and replace them with N
# snippy-clean_full_aln core.full.aln > clean.full.aln

# gubbins to detect recombination
# use Kirschneri as outgroup
# $software_path/bin/run_gubbins.py --threads 50 \
# -v -p $dir_path/gubbins/all_interrogans_gubbins \
# $dir_path/snippy/clean.full.aln