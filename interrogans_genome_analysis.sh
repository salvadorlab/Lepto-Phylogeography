#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N fastANI                                      
#PBS -l nodes=1:ppn=64 -l mem=100gb                                        
#PBS -l walltime=80:00:00                                                
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


#########################################################
#
# PIRATE - for core genome detection
#
##########################################################

# intra-species MCL value = 2 (default)
# to identify core-pan genome for all interrogans isolates
# $software_path/bin/PIRATE \
# -i $dir_path/prokka \
# -o $dir_path/pirate \
# -a -r -t 30

# # parse PIRATE outputs 
# perl PIRATE_to_roary.pl -i /scratch/rx32940/interrogans_genome/pirate/PIRATE.*.tsv -o /scratch/rx32940/interrogans_genome/pirate/roary_presence_absence

#########################################################
#
# PIRATE - for core genome detection
#
##########################################################

# # recontruct the ML tree with core genome concatenation produced by PIRATE
# # this will be used in python code for plot fastGear results
# module load IQ-TREE/1.6.5-omp
# iqtree -nt AUTO -m MFP -pre $dir_path/iqtree/all_int_core \
# -s $dir_path/pirate/core_alignment.fasta 


#########################################################
#
# fastGear - detect recombination within each gene
#
##########################################################

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

# # get genes with only one sequence per loci in genes present in all 440 interrogans isolates
# echo "" > $dir_path/one_seq_loci.txt
# cat $dir_path/genes_in_all_int.txt |\
# while read gene;
# do
# # echo $gene
# n_lineage=$(cat "$dir_path"/fastGear/"$gene"/output/lineage_information.txt | wc -l)
# # echo $n_lineage
# if [[ "$n_lineage" -eq 441 ]]
# then
# echo "in"
# echo -e $gene >> $dir_path/one_seq_loci.txt
# fi
# done

#########################################################
# plot fastGear results
##########################################################

# # # # plot scatterplot for all genes in pan genome
# # 1*) have to login as ssh -Y sapelo2
# #
# # 2*) module load Biopython/1.68-foss-2016b-Python-3.5.2 
# #    module load Anaconda3/5.0.1
# # 
# # 3) to add gene alignment for each gene inside corresponding fatsGear gene folder
# # cat $dir_path/all_loci_fastGear.txt | xargs -I{} cp $dir_path/pirate/feature_sequences/{}.nucleotide.fasta $dir_path/fastGear/{}/{}.fasta 
# # 
# # 4) reformat strain name within lineage_information.txt and recombinations_recent.txt
# # 
# # 5) mkdir $dir_path/post_fastGear/fastGear_oneloci/, for loci with one seq per isolates in all isolates
# #  cat $dir_path/one_seq_loci.txt | xargs -I{} scp -r $dir_path/fastGear/{} $dir_path/post_fastGear/fastGear_oneloci/
# # for heat map with 191 gene with one seq/loci found in all isolates
# python /home/rx32940/github/Lepto-Phylogeography/post_fastGEAR.py \
# -i $dir_path/post_fastGear/fastGear_oneloci/ \
# -g $dir_path/one_seq_loci.txt \
# -o $dir_path/post_fastGear/oneloci \
# -s True -f pdf -p $dir_path/interrogans_acc_440.txt -xs 20 -y 5 -x 0
# # for scatter plot with the use of all genes in all isolates
# python /home/rx32940/github/Lepto-Phylogeography/post_fastGEAR.py \
# -i $dir_path/fastGear \
# -g $dir_path/all_loci_fastGear.txt \
# -o $dir_path/post_fastGear/allcog \
# -s True -f pdf -p $dir_path/interrogans_acc_440.txt -z False -y 5 -x 5

#########################################################
#
# Gubbins - detect recombination within core genome alignment (w/noncoding regions)
#
##########################################################

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

#########################################################
#
# fastANI - get ANI score for all vs all samples
#
##########################################################

$software_path/bin/fastANI --ql $dir_path/full_path_all_asm.txt \
--rl $dir_path/full_path_all_asm.txt \
-o $dir_path/fastANI/all_int_ani.out \
--matrix