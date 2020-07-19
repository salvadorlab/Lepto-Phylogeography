#!/bin/bash
#PBS -q batch                                                            
#PBS -N rep_core                                    
#PBS -l nodes=1:ppn=2
#PBS -l mem=100gb                                        
#PBS -l walltime=300:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

cd /scratch/rx32940/get_homo/


# ml GETHOMOLOGUES/1.7.6

module load GD/2.69-GCCcore-7.3.0-Perl-5.28.0
module load BioPerl/1.7.1-foss-2016b-Perl-5.24.1
module load GCCcore/5.4.0
Rscript /scratch/rx32940/load_packages.r

# default aglorithm doesn't have -t 0 option available (see manual section 4.8)

# 1) use COG algorithm with all possible clusters (even thus which might not contain sequences from all input genomes (taxa)) -t 0 to report all clusters
#       1.1) used -o for blast search only, delete -o for orthologous genes clustering after blast
# 2) remove -o, do COG orthologous analysis
# 3) use -c for genome composition analysis, produce tab file for parse_pangenome_matrix.pl
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/gbk -G -n 64 -c -z
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/gbk_bdbh -n 64 -c -z

# use OMCL algorithm with all possible clusters
# get_homologues.pl -d /scratch/rx32940/get_homo/gbk_dup -t 0 -M -n 48

# use BDBH to get the orthologous genes for all latino and caribbean isolates
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/latin_isolates/gbk_latin_bdbh -n 24 -c -z

# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/parse_pangenome_matrix.pl -m /scratch/rx32940/get_homo/gbk_latin_bdbh_homologues/SAMN11389084_f0_alltaxa_algBDBH_e0_ -s


# classify pangenome into four departments
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/parse_pangenome_matrix.pl -m /scratch/rx32940/get_homo/gbk_homologues/SAMN02947784_f0_0taxa_algCOG_e0_ -s






# pangenome analysis for 106 representative isolates with COG/OMCL algorithm (manual 4.8.1)
/scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/pangenome/gbk_subset -n 24 -t 0 -M
/scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/pangenome/gbk_subset -n 24 -t 0 -G

# get the intersection of clusters analyzed with the two differen clusters
/scratch/rx32940/get_homo/get_homologues-x86_64-20170302/compare_clusters.pl -m -o gbk_subset_intersection -d gbk_subset_homologues/SAMN02603616_f0_0taxa_algCOG_e0_,gbk_subset_homologues/SAMN02603616_f0_0taxa_algOMCL_e0_

# analyze the intersected pangenome of representative isolates
/scratch/rx32940/get_homo/get_homologues-x86_64-20170302/parse_pangenome_matrix.pl -m /scratch/rx32940/get_homo/gbk_subset_intersection/pangenome_matrix_t0.tab -s