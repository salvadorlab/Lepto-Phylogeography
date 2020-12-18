#!/bin/bash
#SBATCH --partition=highmem_30d_p
#SBATCH --job-name=iqtree_pathogenic_sero
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=24             
#SBATCH --time=500:00:00
#SBATCH --mem=400G
#SBATCH --output=/scratch/rx32940/iqtree_pathogenic_sero.%j.out       
#SBATCH --error=/scratch/rx32940/iqtree_pathogenic_sero.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL   


dir_path="/scratch/rx32940/pathogenic_sero"
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
# inter-species MCL value = 6
# to identify core-pan genome for all interrogans isolates
# cd $dir_path/
# $software_path/bin/PIRATE \
# -i $dir_path/prokka_gff \
# -o $dir_path/pirate \
# -a -r -t 24 \
# -pan-opt "-f 6"

# # parse PIRATE outputs 
# perl $software_path/tools/convert_format/PIRATE_to_roary.pl -i $dir_path/pirate/PIRATE.*.tsv -o $dir_path/pirate/pirate_roary_pres_abs.csv

#########################################################
#
# IQTREE - for core genome concatenation ML tree
#
##########################################################

# # recontruct the ML tree with core genome concatenation produced by PIRATE
# # this will be used in python code for plot fastGear results
module load IQ-TREE/1.6.5-omp
cd $dir_path/core_iqtree/
iqtree -nt AUTO -m MFP -pre $dir_path/core_iqtree/core_patho_sero_iqtree \
-s $dir_path/pirate/core_alignment.fasta 

## Do Scoary GWAS analysis with presence/absence of the gene
# cd $dir_path/pirate_sero/scoary
# $software_path/bin/scoary -g $dir_path/pirate_sero/out/pirate_roary_pres_abs.csv -t $dir_path/pirate_sero/scoary/scoary_serogroup_trait.csv \
# --collapse -n $dir_path/iqtree/int_sero_iqtree.newick --threads 24 \
# -o $dir_path/pirate_sero/scoary/scoary_serogroup_result -e 10000 \
# -c I BH P -p 0.05

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
#     list_name=$(basename "$list")
#     echo "create script for $list"
#     (
    
#     echo -e "in loop"
#     job_header="#!/bin/bash 
# #SBATCH --partition=batch 
# #SBATCH --job-name=$list_name 
# #SBATCH --ntasks=1 
# #SBATCH --cpus-per-task=8 
# #SBATCH --mem=50G 
# #SBATCH --time=100:00:00
# #SBATCH --output=/scratch/rx32940/$list_name.%j.out 
# #SBATCH --error=/scratch/rx32940/$list_name.%j.out 
# #SBATCH --mail-user=rx32940@uga.edu 
# #SBATCH --mail-type=ALL"

#     echo -e "$job_header" > $dir_path/submit_sub_fastGear.sh

#     echo -e "$script_path" >> $dir_path/submit_sub_fastGear.sh

#     echo -e "cat $list | xargs -I{} \
#     $fastGear_path/run_fastGEAR.sh $matlab_path \
#     $file_path/{}.nucleotide.fasta \
#     $dir_path/fastGear/{}/interrogans_{}.mat \
#     $fastGear_path/fG_input_specs.txt" >> $dir_path/submit_sub_fastGear.sh

#     sbatch $dir_path/submit_sub_fastGear.sh
    
#     echo -e "submitted script for $list_name"
#     ) &
#     echo "waiting"
#     wait
# done

# # get genes with only one sequence per loci in genes present in all 439 interrogans isolates
# echo "" > $dir_path/one_seq_loci.txt
# cat $dir_path/genes_in_all_int.txt |\
# while read gene;
# do
# # echo $gene
# n_lineage=$(cat "$dir_path"/fastGear/"$gene"/output/lineage_information.txt | wc -l)
# # echo $n_lineage
# if [[ "$n_lineage" -eq 440 ]]
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
# # cat $dir_path/genes_in_all_int.txt | xargs -I{} cp $dir_path/pirate/feature_sequences/{}.nucleotide.fasta $dir_path/fastGear/{}/{}.fasta 
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
# -s True -f pdf -p $dir_path/gubbins_noref/all_interrogans_gubbins_noref.final_tree.tre -xs 40 -y 0 -x 0
# # for scatter plot with the use of all genes in all isolates
# python /home/rx32940/github/Lepto-Phylogeography/post_fastGEAR.py \
# -i $dir_path/fastGear \
# -g $dir_path/all_loci_fastGear.txt \
# -o $dir_path/post_fastGear/allcog \
# -s True -f pdf -p $dir_path/iqtree/int_no_lb_core.newick -z False -y 100 -x 100

#########################################################
#
# Gubbins - detect recombination within all genome alignment (w/noncoding regions) 
# with reference to a reference genome (coordinates with recombination and masking are corresponding to the reference)
#
##########################################################

# run snippy- generate script
# # snippy_input.tab generation refer to github issue
# cd $dir_path/pirate_sero/gubbins/snippy
# $software_path/bin/snippy-multi $dir_path/pirate_sero/snippy_input.tab \
# --ref $dir_path/GCF_000092565.1_ASM9256v1_genomic.fna --cpus 12 > \
# run_snippy.sh

# combine all whole genome alignment with all isolates with the reference genome
# mask the phage region with PHASTER in the reference genome
# # use Phaster to detect prophages in the reference genome for masking
# # for bed file op tutorial: http://gizemlevent.com/masking-bacteriophage-regions-for-phylogenetic-tree-analysis/, but with exceptions
# /home/rx32940/miniconda3/bin/snippy-core --mask "$dir_path/snippy/phage_region.bed" \
# --ref '/scratch/rx32940/interrogans_genome/GCF_000092565.1_ASM9256v1_genomic.fna' SAMEA1012006 SAMEA1012014 SAMEA1012026 SAMEA104369440 SAMEA104369441 SAMEA5168039 SAMEA5168040 SAMEA5168050 SAMEA5168052 SAMEA5168053 SAMEA5168085 SAMEA5168086 SAMEA5168088 SAMEA5168126 SAMEA5168127 SAMEA5168151 SAMEA5168152 SAMEA5168153 SAMEA5168160 SAMEA5168161 SAMEA5168166 SAMEA5168169 SAMEA5168176 SAMEA5168180 SAMEA5168181 SAMEA5168184 SAMEA5168187 SAMEA5168191 SAMEA5168192 SAMEA5168193 SAMEA5168197 SAMEA5168198 SAMEA5168203 SAMEA5168205 SAMEA5168207 SAMEA5168208 SAMEA5168212 SAMEA5168213 SAMEA5168215 SAMEA5168217 SAMEA5168218 SAMEA5168222 SAMEA5168235 SAMEA5168240 SAMEA5168253 SAMEA5168254 SAMEA5168255 SAMEA5168256 SAMEA5168257 SAMEA5168259 SAMEA5168260 SAMEA5168262 SAMEA5168263 SAMEA5168267 SAMEA5168269 SAMEA5168273 SAMEA5168309 SAMEA5168319 SAMEA5168338 SAMEA5168339 SAMEA5168340 SAMEA5168341 SAMEA5168342 SAMEA5168343 SAMEA5168344 SAMEA864081 SAMEA864082 SAMEA864083 SAMEA864084 SAMEA864085 SAMEA864086 SAMEA864090 SAMEA864092 SAMEA864094 SAMEA864095 SAMEA864096 SAMEA864097 SAMEA864098 SAMEA864099 SAMEA864100 SAMEA864101 SAMEA864102 SAMEA864103 SAMEA864105 SAMEA864106 SAMEA864110 SAMEA864112 SAMEA864113 SAMEA864114 SAMEA864116 SAMEA864117 SAMEA864118 SAMEA864119 SAMEA864120 SAMEA864121 SAMEA864122 SAMEA864123 SAMEA864124 SAMEA864125 SAMEA864126 SAMEA864127 SAMEA864128 SAMEA864129 SAMEA864130 SAMEA864131 SAMEA864132 SAMEA864133 SAMEA864134 SAMEA864135 SAMEA864136 SAMEA864137 SAMEA864138 SAMEA864139 SAMEA864140 SAMEA864141 SAMEA864142 SAMEA864143 SAMEA864144 SAMEA864146 SAMEA864147 SAMEA864149 SAMEA864152 SAMEA864153 SAMEA864157 SAMEA864159 SAMEA864161 SAMEA864162 SAMEA864163 SAMEA864164 SAMEA864165 SAMEA864167 SAMEA864169 SAMEA864170 SAMEA864172 SAMEA864174 SAMEA864175 SAMEA864176 SAMEA864178 SAMEA864179 SAMN00254324 SAMN00254328 SAMN00254329 SAMN00254330 SAMN00254332 SAMN00254333 SAMN00254334 SAMN00254335 SAMN00254336 SAMN00254342 SAMN00254352 SAMN00254358 SAMN00254363 SAMN00254365 SAMN00254379 SAMN00254380 SAMN00254991 SAMN00254992 SAMN00255265 SAMN00771460 SAMN00771461 SAMN00771485 SAMN00771489 SAMN00780044 SAMN00780046 SAMN00780047 SAMN00780062 SAMN00780063 SAMN00780064 SAMN00839694 SAMN01047824 SAMN01047825 SAMN01047827 SAMN01047831 SAMN01047843 SAMN01047846 SAMN01047848 SAMN01047849 SAMN01047852 SAMN01047855 SAMN01047856 SAMN01047857 SAMN01047858 SAMN01047859 SAMN01047860 SAMN01047862 SAMN01047864 SAMN01047865 SAMN01047866 SAMN01047867 SAMN01047868 SAMN01047870 SAMN01047920 SAMN01048184 SAMN01162014 SAMN01162016 SAMN01162020 SAMN01162021 SAMN01162029 SAMN01766539 SAMN01801580 SAMN01801593 SAMN01801595 SAMN01801596 SAMN01801606 SAMN01886734 SAMN01886735 SAMN01886736 SAMN01919676 SAMN01919801 SAMN01919802 SAMN01919803 SAMN01919804 SAMN01919808 SAMN01919809 SAMN01920105 SAMN01920108 SAMN01920112 SAMN01920115 SAMN01920118 SAMN01920121 SAMN01920124 SAMN01920127 SAMN01920130 SAMN01920564 SAMN01920565 SAMN01920566 SAMN01920567 SAMN01920568 SAMN01920569 SAMN01920570 SAMN01920587 SAMN01920588 SAMN01920589 SAMN01920590 SAMN01920591 SAMN01920592 SAMN01920593 SAMN01920595 SAMN01920596 SAMN01920597 SAMN01920604 SAMN01920605 SAMN01920608 SAMN01920609 SAMN01920610 SAMN01920611 SAMN01920617 SAMN01920618 SAMN01920619 SAMN01920620 SAMN01920621 SAMN01920622 SAMN01920624 SAMN01920626 SAMN01920628 SAMN01920629 SAMN01920630 SAMN01920631 SAMN01920632 SAMN01920633 SAMN02436336 SAMN02436373 SAMN02436374 SAMN02436375 SAMN02436376 SAMN02436377 SAMN02436378 SAMN02436379 SAMN02436381 SAMN02436410 SAMN02436413 SAMN02436416 SAMN02436424 SAMN02436425 SAMN02436427 SAMN02436428 SAMN02436429 SAMN02436430 SAMN02436433 SAMN02436483 SAMN02436487 SAMN02436488 SAMN02436490 SAMN02436495 SAMN02436498 SAMN02436501 SAMN02436502 SAMN02436505 SAMN02436506 SAMN02436508 SAMN02436546 SAMN02436547 SAMN02436548 SAMN02436575 SAMN02436576 SAMN02436582 SAMN02436589 SAMN02436590 SAMN02436591 SAMN02436628 SAMN02436629 SAMN02603127 SAMN02603847 SAMN02603861 SAMN02673560 SAMN02928167 SAMN02947410 SAMN02947765 SAMN02947972 SAMN02949511 SAMN02949512 SAMN02949513 SAMN02949514 SAMN02949515 SAMN02949516 SAMN02949517 SAMN02949518 SAMN02949520 SAMN02949521 SAMN02949523 SAMN02949524 SAMN02949526 SAMN02949527 SAMN02949529 SAMN02949530 SAMN02949532 SAMN02949533 SAMN02949535 SAMN02949536 SAMN02949537 SAMN02949538 SAMN02949539 SAMN02949540 SAMN02949541 SAMN02949542 SAMN02949543 SAMN02949544 SAMN02949545 SAMN02949546 SAMN02949547 SAMN02949548 SAMN02949549 SAMN02949554 SAMN02949555 SAMN02949556 SAMN02949557 SAMN02949558 SAMN02949559 SAMN02949560 SAMN02949561 SAMN02949562 SAMN02949563 SAMN02949564 SAMN02949565 SAMN02949566 SAMN02949567 SAMN02949568 SAMN02949569 SAMN02949570 SAMN02949571 SAMN02949572 SAMN02949573 SAMN02949574 SAMN02949575 SAMN02949576 SAMN02949577 SAMN02949579 SAMN03259167 SAMN03610058 SAMN03780437 SAMN03780438 SAMN03783263 SAMN03783264 SAMN03853357 SAMN03944914 SAMN03996887 SAMN03996952 SAMN03996955 SAMN03997006 SAMN03997015 SAMN03998754 SAMN03998756 SAMN03998757 SAMN04002971 SAMN04009303 SAMN04009307 SAMN04009327 SAMN04009367 SAMN04090017 SAMN04090071 SAMN04090075 SAMN04102139 SAMN04102140 SAMN04102160 SAMN04102260 SAMN04116739 SAMN04116740 SAMN04116742 SAMN04145567 SAMN04145570 SAMN04145571 SAMN04145899 SAMN04145914 SAMN04145947 SAMN04145962 SAMN04145963 SAMN04158468 SAMN04158538 SAMN04231379 SAMN04235587 SAMN04432834 SAMN04555632 SAMN05195242 SAMN05195243 SAMN05421689 SAMN06233881 SAMN06290125 SAMN06298621 SAMN06298624 SAMN06434252 SAMN06434273 SAMN07313955 SAMN07314877 SAMN07501985 SAMN07502166 SAMN08513768 SAMN08596279 SAMN11289419 SAMN11289420 SAMN11289421 SAMN11774874 SAMN11774875 SAMN11774876 SAMN11774877 SAMN12567456 SAMN12567526 SAMN12588099 SAMN12871420 SAMN12871448

# # remove all the "weird" characters and replace them with N
# core.full.aln contains sequences all with same length as the reference, with sites with zero coverage in this sample or a deletion relative to the reference substitute by "-"
# snippy-clean_full_aln $dir_path/snippy/core.full.aln > $dir_path/snippy/clean.full.aln

# remove Reference genome from the final snippy alignment (with invariant sites)
# -v invert matching
# -p pattern
# cat $dir_path/snippy/clean.full.aln | seqkit grep -v -p Reference > $dir_path/snippy/clean.full.noref.aln 

# # gubbins to detect recombination
# cd $dir_path/pirate_sero/gubbins
# $software_path/bin/run_gubbins.py --threads 24 \
# -v -p $dir_path/pirate_sero/gubbins/interrogans_sero \
# $dir_path/pirate_sero/gubbins/snippy/clean.full.noref.aln


# get the snps from recombination free regions
# snp-sites -c all_interrogans_gubbins_noref.filtered_polymorphic_sites.fasta > snps_after_gubbins_aln.fasta

# reconstruct a phylogenetic tree with recombination free regions' SNPs

# module load IQ-TREE/1.6.12-intel-2019b
# iqtree -m MFP+ASC -nt AUTO -pre $dir_path/iqtree/snps_noRecom -s $dir_path/gubbins_noref/snps_after_gubbins_aln.fasta



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
