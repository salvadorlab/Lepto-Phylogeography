#!/bin/bash
#SBATCH --partition=highmem_30d_p
#SBATCH --job-name=gubbins_pathogenic_sero
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=36             
#SBATCH --time=500:00:00
#SBATCH --mem=400G
#SBATCH --output=/scratch/rx32940/gubbins_pathogenic_sero.%j.out       
#SBATCH --error=/scratch/rx32940/gubbins_pathogenic_sero.%j.out        
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
# module load IQ-TREE/1.6.5-omp
cd $dir_path/core_iqtree/
# # GTR+F+R5 was determined in a previous iqtree run killed due to time limit
iqtree -nt AUTO -m GTR+F+R5 -pre $dir_path/core_iqtree/core_patho_sero_iqtree \
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
# cd $dir_path
# $software_path/bin/snippy-multi $dir_path/snippy_input.tab \
# --ref $dir_path/GCF_000092565.1_ASM9256v1_genomic.fna --cpus 12 > \
# run_snippy.sh

# combine all whole genome alignment with all isolates with the reference genome
# mask the phage region with PHASTER in the reference genome
# # use Phaster to detect prophages in the reference genome for masking
# cd $dir_path/snippy
# # for bed file op tutorial: http://gizemlevent.com/masking-bacteriophage-regions-for-phylogenetic-tree-analysis/, but with exceptions
# $software_path/bin/snippy-core --mask "$dir_path/snippy/phage_region.bed" --ref "$dir_path/GCF_000092565.1_ASM9256v1_genomic.fna" SAMEA1012006 SAMEA1012014 SAMEA1012026 SAMEA104369440 SAMEA104369441 SAMEA5168035 SAMEA5168036 SAMEA5168039 SAMEA5168040 SAMEA5168041 SAMEA5168042 SAMEA5168043 SAMEA5168044 SAMEA5168045 SAMEA5168046 SAMEA5168047 SAMEA5168048 SAMEA5168049 SAMEA5168052 SAMEA5168053 SAMEA5168054 SAMEA5168055 SAMEA5168056 SAMEA5168057 SAMEA5168060 SAMEA5168061 SAMEA5168062 SAMEA5168085 SAMEA5168086 SAMEA5168088 SAMEA5168089 SAMEA5168096 SAMEA5168126 SAMEA5168127 SAMEA5168159 SAMEA5168160 SAMEA5168161 SAMEA5168162 SAMEA5168163 SAMEA5168165 SAMEA5168166 SAMEA5168178 SAMEA5168179 SAMEA5168180 SAMEA5168181 SAMEA5168183 SAMEA5168184 SAMEA5168186 SAMEA5168187 SAMEA5168191 SAMEA5168192 SAMEA5168193 SAMEA5168195 SAMEA5168196 SAMEA5168197 SAMEA5168198 SAMEA5168202 SAMEA5168203 SAMEA5168204 SAMEA5168205 SAMEA5168207 SAMEA5168208 SAMEA5168209 SAMEA5168210 SAMEA5168211 SAMEA5168212 SAMEA5168213 SAMEA5168215 SAMEA5168216 SAMEA5168217 SAMEA5168218 SAMEA5168238 SAMEA5168240 SAMEA5168241 SAMEA5168242 SAMEA5168243 SAMEA5168249 SAMEA5168250 SAMEA5168251 SAMEA5168252 SAMEA5168253 SAMEA5168254 SAMEA5168255 SAMEA5168256 SAMEA5168257 SAMEA5168258 SAMEA5168259 SAMEA5168260 SAMEA5168261 SAMEA5168262 SAMEA5168263 SAMEA5168275 SAMEA5168276 SAMEA864081 SAMEA864082 SAMEA864083 SAMEA864084 SAMEA864085 SAMEA864086 SAMEA864090 SAMEA864092 SAMEA864094 SAMEA864095 SAMEA864096 SAMEA864097 SAMEA864098 SAMEA864099 SAMEA864100 SAMEA864101 SAMEA864102 SAMEA864103 SAMEA864105 SAMEA864106 SAMEA864110 SAMEA864112 SAMEA864113 SAMEA864114 SAMEA864116 SAMEA864117 SAMEA864118 SAMEA864119 SAMEA864120 SAMEA864121 SAMEA864122 SAMEA864123 SAMEA864124 SAMEA864125 SAMEA864126 SAMEA864127 SAMEA864128 SAMEA864129 SAMEA864130 SAMEA864131 SAMEA864132 SAMEA864133 SAMEA864134 SAMEA864135 SAMEA864136 SAMEA864137 SAMEA864138 SAMEA864139 SAMEA864140 SAMEA864141 SAMEA864142 SAMEA864143 SAMEA864144 SAMEA864146 SAMEA864147 SAMEA864149 SAMEA864152 SAMEA864153 SAMEA864157 SAMEA864159 SAMEA864161 SAMEA864164 SAMEA864165 SAMEA864166 SAMEA864167 SAMEA864169 SAMEA864170 SAMEA864172 SAMEA864174 SAMEA864175 SAMEA864176 SAMEA864178 SAMEA864179 SAMN00254324 SAMN00254325 SAMN00254326 SAMN00254327 SAMN00254328 SAMN00254329 SAMN00254330 SAMN00254332 SAMN00254333 SAMN00254334 SAMN00254335 SAMN00254336 SAMN00254337 SAMN00254338 SAMN00254339 SAMN00254340 SAMN00254341 SAMN00254342 SAMN00254343 SAMN00254344 SAMN00254345 SAMN00254346 SAMN00254347 SAMN00254348 SAMN00254349 SAMN00254350 SAMN00254351 SAMN00254352 SAMN00254353 SAMN00254354 SAMN00254355 SAMN00254356 SAMN00254358 SAMN00254359 SAMN00254361 SAMN00254362 SAMN00254363 SAMN00254364 SAMN00254365 SAMN00254366 SAMN00254367 SAMN00254369 SAMN00254370 SAMN00254371 SAMN00254372 SAMN00254373 SAMN00254375 SAMN00254376 SAMN00254377 SAMN00254378 SAMN00254379 SAMN00254380 SAMN00254381 SAMN00254382 SAMN00254991 SAMN00254992 SAMN00255258 SAMN00255260 SAMN00255261 SAMN00255265 SAMN00739244 SAMN00739254 SAMN00739291 SAMN00739295 SAMN00739360 SAMN00739361 SAMN00739362 SAMN00739363 SAMN00739364 SAMN00739365 SAMN00739366 SAMN00739367 SAMN00739368 SAMN00739369 SAMN00739370 SAMN00739371 SAMN00739372 SAMN00739373 SAMN00739374 SAMN00739375 SAMN00739376 SAMN00739377 SAMN00739378 SAMN00739379 SAMN00739380 SAMN00739381 SAMN00739382 SAMN00739383 SAMN00739384 SAMN00739385 SAMN00739388 SAMN00739389 SAMN00739390 SAMN00739391 SAMN00739392 SAMN00739395 SAMN00739396 SAMN00739397 SAMN00771460 SAMN00771461 SAMN00771485 SAMN00771492 SAMN00780044 SAMN00780053 SAMN00780054 SAMN00780056 SAMN00780058 SAMN00780059 SAMN00780061 SAMN00780064 SAMN00839694 SAMN01036683 SAMN01036700 SAMN01036874 SAMN01047824 SAMN01047825 SAMN01047827 SAMN01047830 SAMN01047831 SAMN01047842 SAMN01047846 SAMN01047849 SAMN01047854 SAMN01047855 SAMN01047856 SAMN01047857 SAMN01047858 SAMN01047860 SAMN01047863 SAMN01047866 SAMN01047867 SAMN01047870 SAMN01047919 SAMN01047920 SAMN01048184 SAMN01048185 SAMN01162013 SAMN01162016 SAMN01162020 SAMN01798240 SAMN01801580 SAMN01801594 SAMN01801597 SAMN01801604 SAMN01801606 SAMN01886724 SAMN01886735 SAMN01886736 SAMN01919676 SAMN01919773 SAMN01919801 SAMN01919802 SAMN01919804 SAMN01919805 SAMN01919806 SAMN01919807 SAMN01919808 SAMN01919809 SAMN01920105 SAMN01920108 SAMN01920112 SAMN01920115 SAMN01920118 SAMN01920121 SAMN01920124 SAMN01920127 SAMN01920564 SAMN01920565 SAMN01920566 SAMN01920567 SAMN01920568 SAMN01920569 SAMN01920570 SAMN01920587 SAMN01920588 SAMN01920589 SAMN01920590 SAMN01920591 SAMN01920592 SAMN01920593 SAMN01920595 SAMN01920596 SAMN01920597 SAMN01920604 SAMN01920605 SAMN01920608 SAMN01920609 SAMN01920610 SAMN01920611 SAMN01920617 SAMN01920618 SAMN01920619 SAMN01920621 SAMN01920622 SAMN01920623 SAMN01920624 SAMN01920625 SAMN01920626 SAMN01920628 SAMN01920629 SAMN01920630 SAMN01920631 SAMN01920632 SAMN01920633 SAMN01994529 SAMN02436336 SAMN02436368 SAMN02436369 SAMN02436371 SAMN02436373 SAMN02436375 SAMN02436376 SAMN02436379 SAMN02436380 SAMN02436381 SAMN02436382 SAMN02436395 SAMN02436408 SAMN02436410 SAMN02436411 SAMN02436412 SAMN02436414 SAMN02436417 SAMN02436423 SAMN02436427 SAMN02436428 SAMN02436429 SAMN02436430 SAMN02436433 SAMN02436434 SAMN02436435 SAMN02436483 SAMN02436487 SAMN02436490 SAMN02436499 SAMN02436501 SAMN02436502 SAMN02436505 SAMN02436507 SAMN02436508 SAMN02436546 SAMN02436547 SAMN02436571 SAMN02436575 SAMN02436576 SAMN02436588 SAMN02436589 SAMN02436591 SAMN02436592 SAMN02470123 SAMN02603127 SAMN02603615 SAMN02603616 SAMN02603847 SAMN02603861 SAMN02673560 SAMN02928167 SAMN02928168 SAMN03135151 SAMN03259167 SAMN03375751 SAMN03610058 SAMN03780437 SAMN03780438 SAMN03783263 SAMN03783264 SAMN03853357 SAMN03996887 SAMN03996952 SAMN03996955 SAMN03997006 SAMN03997015 SAMN03998754 SAMN03998756 SAMN03998757 SAMN04002971 SAMN04090017 SAMN04090071 SAMN04090075 SAMN04102082 SAMN04102083 SAMN04102097 SAMN04102139 SAMN04102140 SAMN04102142 SAMN04102143 SAMN04102160 SAMN04102260 SAMN04116739 SAMN04116740 SAMN04116742 SAMN04145567 SAMN04145570 SAMN04145571 SAMN04145899 SAMN04145914 SAMN04145947 SAMN04145962 SAMN04145963 SAMN04156848 SAMN04158468 SAMN04158538 SAMN04432834 SAMN04555632 SAMN04875540 SAMN05195242 SAMN05195243 SAMN06103775 SAMN06212380 SAMN06212381 SAMN06212382 SAMN06212383 SAMN06233881 SAMN06290125 SAMN06298621 SAMN06298624 SAMN06327236 SAMN06328787 SAMN06328788 SAMN06434252 SAMN06434273 SAMN06830783 SAMN07501985 SAMN07502166 SAMN07620965 SAMN08498447 SAMN08513768 SAMN08596279 SAMN09926239 SAMN10983505 SAMN12567456 SAMN12567526 SAMN12588099 SAMN12721651 SAMN12721652 SAMN12721653 SAMN12721654 SAMN12721655 SAMN12721657 SAMN12871420 SAMN12871448 SAMN13046976 SAMN13679794 SAMN13822336 SAMN14582900 SAMN14582901 SAMN14582902 SAMN16295614 SAMN16295615 SAMN16295616 SAMN16295617 SAMN16295618 SAMN16295619 SAMN16295620 SAMN16295621 SAMN16295623 SAMN16295625 SAMN16295631 SAMN16295632 SAMN16295634 SAMN16295637 SAMN16295638 SAMN16295639 SAMN16295640 SAMN16295641 SAMN16295642 SAMN16295643 SAMN16295647 SAMN16295648 SAMN16295649 SAMN16295651 SAMN16295652 SAMN16295653 SAMN16295654 SAMN16295655 SAMN16295656 SAMN16295657 SAMN16295658 SAMN16295659 SAMN16295660 SAMN16295661 SAMN16295662 SAMN16295663 SAMN16295664 SAMN16295665 SAMN16295666 SAMN16295667 SAMN16295668 SAMN16295669 SAMN16295670 SAMN16295671 SAMN16295672 SAMN16295673 SAMN16295674 SAMN16295675 SAMN16295676 SAMN16295677 SAMN16295678 SAMN16295679 SAMN16295680 SAMN16295681 SAMN16295682 SAMN16295683 SAMN16295684 SAMN16295685 SAMN16295686 SAMN16295687 SAMN16295688 SAMN16295689 SAMN16295690 SAMN16295691 SAMN16295692 SAMN16295693 SAMN16295694 SAMN16295695 SAMN16295696 SAMN16295697 SAMN16295698 SAMN16295699 SAMN16295700 SAMN16295701 SAMN16295702 SAMN16295703 SAMN16295704 SAMN16295705 SAMN16295708 SAMN16295709 SAMN16295710 SAMN16295711 SAMN16295712 SAMN16295713
# # remove all the "weird" characters and replace them with N
# core.full.aln contains sequences all with same length as the reference, with sites with zero coverage in this sample or a deletion relative to the reference substitute by "-"
# snippy-clean_full_aln $dir_path/snippy/core.full.aln > $dir_path/snippy/clean.full.aln

# remove Reference genome from the final snippy alignment (with invariant sites)
# -v invert matching
# -p pattern
# cat $dir_path/snippy/clean.full.aln | seqkit grep -v -p Reference > $dir_path/snippy/clean.full.noref.aln 

# # gubbins to detect recombination
# cd $dir_path/gubbins
# $software_path/bin/run_gubbins.py --threads 24 \
# -v -p $dir_path/gubbins/pathogenic_sero \
# $dir_path/snippy/clean.full.noref.aln


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
