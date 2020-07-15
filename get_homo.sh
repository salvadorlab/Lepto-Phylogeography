#!/bin/bash
#PBS -q bahl_salv_q                                                            
#PBS -N COG_core                                    
#PBS -l nodes=1:ppn=2
#PBS -l mem=100gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

cd /scratch/rx32940/get_homo/


# ml GETHOMOLOGUES/1.7.6
module load R/4.0.0-foss-2019b
module load GD/2.66-foss-2016b-Perl-5.24.1
# default aglorithm doesn't have -t 0 option available (see manual section 4.8)

# 1) use COG algorithm with all possible clusters (even thus which might not contain sequences from all input genomes (taxa)) -t 0 to report all clusters
#       1.1) used -o for blast search only, delete -o for orthologous genes clustering after blast
# 2) remove -o, do COG orthologous analysis
# 3) use -c for genome composition analysis, produce tab file for parse_pangenome_matrix.pl
/scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/gbk -G -n 64 -c -z
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/gbk_bdbh -n 64 -c -z

# use OMCL algorithm with all possible clusters
# get_homologues.pl -d /scratch/rx32940/get_homo/gbk_dup -t 0 -M -n 48

# use BDBH to get the orthologous genes for all latino and caribbean isolates
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/get_homo/latin_isolates/gbk_latin_bdbh -n 24 -c -z

# classify pangenome into four departments
# parse_pangenome_matrix.pl -m /scratch/rx32940/get_homo/gbk_homologues/SAMN02947784_f0_0taxa_algCOG_e0_ -s

# pangenome analysis for 106 representative isolates with COG algorithm (manual 4.8.1)
# /scratch/rx32940/get_homo/get_homologues-x86_64-20170302/get_homologues.pl -d /scratch/rx32940/pangenome/gbk_subset -n 24 -t 0 -M
