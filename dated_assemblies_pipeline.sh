#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N trim_double                                        
#PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

###################################################################
#
# fastq files with runs (technical replicates) merged into one
# quality check
#
####################################################################

# path_51="/scratch/rx32940/merged_runs"
# path_qc="/scratch/rx32940/Lepto_Work/fastqc/" 

# module load FastQC/0.11.8-Java-1.8.0_144

# all_files=$(ls -d "$path_51"/*) # list absolute path of all files in the dir

# fastqc -t 12 -o fastqc -o $path_qc -f fastq $all_files # do fastqc for all 51 at once

######################################################################
#
# multiqc
# Aggregate all fastqc reports for the 51 biosamples with collection date 
#
# #####################################################################

# path_qc="/scratch/rx32940/Lepto_Work/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# 
############################################################################


module load Trimmomatic/0.36-Java-1.8.0_144

# trim single end files
path_seq="/scratch/rx32940/merged_runs"
output_dir="/scratch/rx32940/Lepto_Work/trim"

# for fastq in $path_seq/single/*;
# do
#     biosample=$(basename "$fastq" .fastq.gz)
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     SE -threads 4 $path_seq/single/$biosample.fastq.gz $output_dir/single/${biosample}_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

cat $path_seq/pair.txt | \
while read biosample;
do  
    java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
    PE -threads 4 $path_seq/pair/${biosample}_1.fastq.gz $path_seq/pair/${biosample}_2.fastq.gz \
    $output_dir/pair/${biosample}_1_paired_trimmed.fastq.gz $output_dir/pair/${biosample}_1_unpaired_trimmed.fastq.gz \
    $output_dir/pair/${biosample}_2_paired_trimmed.fastq.gz $output_dir/pair/${biosample}_2_unpaired_trimmed.fastq.gz \
    ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

############################################################################
#
# SPADES
# Assemble the trimmed seq
#
############################################################################


