#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_rest                                       
#PBS -l nodes=1:ppn=24 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

###################################################################
#
# fastqc 
# quality check
# pair end reads
# reverse file: _2,_3,_4
#
####################################################################

# seqpath="/scratch/rx32940/rest_sra_216/SRAseq"
# path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc"

# module load FastQC/0.11.8-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_2.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_2.fastq.gz

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_3.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_3.fastq.gz

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_4.txt |\
# xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1.fastq.gz \
# $seqpath/{}_4.fastq.gz

######################################################################
#
# multiqc
# Aggregate all fastqc reports for the 211 biosamples with collection date 
#
# #####################################################################

path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc" 

module load MultiQC/1.5-foss-2016b-Python-2.7.14

multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# 
############################################################################

# path_seq="/scratch/rx32940/rest_sra_216/SRAseq"
# output_dir="/scratch/rx32940/Lepto_Work/rest_211/trimmed"

# module load Trimmomatic/0.36-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/rest_sra_212.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_2.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done
