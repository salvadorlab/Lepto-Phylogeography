#!/bin/bash
#SBATCH --partition=bahl_salv_p
#SBATCH --job-name=pirate_lb
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=64             
#SBATCH --time=500:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/pirate_lb.%j.out       
#SBATCH --error=/scratch/rx32940/pirate_lb.%j.err         
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL


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
cd $dir_path/pirate
$software_path/bin/PIRATE \
-i $dir_path/prokka \
-o $dir_path/pirate \
-a -r -t 64

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
# -s True -f pdf -p $dir_path/iqtree/all_int_core.newick -xs 40 -y 0 -x 0
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

# remove Reference genome from the final snippy alignment (with invariant sites)
# -v invert matching
# -p pattern
# module load seqkit/0.10.2_conda
# cat $dir_path/snippy/core.full.aln | seqkit grep -v -p Reference > $dir_path/snippy/no_ref_core.fasta 

# recall snps with snp-sites from multi-fasta alignment for snps without reference genome
# snp-sites $dir_path/snippy/snp_sites_core.fasta -o $dir_path/snippy/snps_noref_core.fasta

# # remove all the "weird" characters and replace them with N
# snippy-clean_full_aln $dir_path/snippy/snps_noref_core.fasta > $dir_path/snippy/clean.full.aln

# # gubbins to detect recombination
# cd $dir_path/gubbins_noref
# $software_path/bin/run_gubbins.py --threads 64 \
# -v -p $dir_path/gubbins_noref/all_interrogans_gubbins_noref \
# $dir_path/snippy/clean.full.aln

# keep only the containing exclusively ACGT
# snp-sites -c $dir_path/gubbins/all_interrogans_gubbins.filtered_polymorphic_sites.fasta > $dir_path/gubbins/clean.core.aln
#########################################################
#
# fastANI - get ANI score for all vs all samples
#
##########################################################

# cd $dir_path/fastANI/
# $software_path/bin/fastANI --ql $dir_path/full_path_all_asm.txt \
# --rl $dir_path/full_path_all_asm.txt \
# -o $dir_path/fastANI/all_int_ani.out \
# --matrix -t 64 > running.log