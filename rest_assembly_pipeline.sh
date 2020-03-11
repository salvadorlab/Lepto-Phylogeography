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

# path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# all trimmed seq with reverse file renamed as _2
# 
############################################################################

# path_seq="/scratch/rx32940/rest_sra_216/SRAseq"
# output_dir="/scratch/rx32940/Lepto_Work/rest_211/trimmed"

# module load Trimmomatic/0.36-Java-1.8.0_144

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_2.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_2.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_3.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_3.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PairEnd_4.txt  | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/${biosample}_1.fastq.gz $path_seq/${biosample}_4.fastq.gz \
#     $output_dir/${biosample}_1_paired_trimmed.fastq.gz $output_dir/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/${biosample}_2_paired_trimmed.fastq.gz $output_dir/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

###################################################################
#
# fastqc 
# 25 seq didn't pass qc, re-qc after trimming
# quality check
# pair end reads
##################################################################################

seqpath="/scratch/rx32940/Lepto_Work/rest_211/trimmed"
path_qc="/scratch/rx32940/Lepto_Work/rest_211/2nd_qc"

module load FastQC/0.11.8-Java-1.8.0_144

cat /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/rest_sra_212.txt |\
xargs -I{} fastqc -t 12 -o fastqc -o $path_qc -f fastq $seqpath/{}_1_paired_trimmed.fastq.gz \
$seqpath/{}_2_paired_trimmed.fastq.gz

######################################################################
#
# multiqc
# see the qualities for rest 211 isolates after trimming 
#
# #####################################################################

path_qc="/scratch/rx32940/Lepto_Work/rest_211/fastqc" 

module load MultiQC/1.5-foss-2016b-Python-2.7.14

multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
#
# SPADES 
# Assemble the trimmed seq 
#
############################################################################


# path_seq="/scratch/rx32940/All_Lepto_Assemblies/rest_sra_216"
# trim_seq="/scratch/rx32940/Lepto_Work/rest_211/trimmed"

# cat $path_seq/rest_sra_212.txt |\

#  while read SAMN; 
#  do
#     echo "Starting command"
#     (
#     echo "$SAMN"
#     sapelo2_header="#!/bin/bash
#         #PBS -q bahl_salv_q                                                            
#         #PBS -N assemble32_pair_$SAMN                                        
#         #PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "

#     echo "$sapelo2_header" > ./sub_assembleRest.sh
#     echo "module load spades/3.12.0-k_245" >> ./sub_assembleRest.sh

#     echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
#     --pe1-1 $trim_seq/${SAMN}_1_paired_trimmed.fastq.gz \
#     --pe1-2 $trim_seq/${SAMN}_2_paired_trimmed.fastq.gz \
#     --careful --mismatch-correction \
#     -o /scratch/rx32940/Lepto_Work/rest_211/assemblies/$SAMN" >> ./sub_assembleRest.sh


#     qsub ./sub_assembleRest.sh
    
#     echo "$SAMN pair-end submitted"
#     ) &

#     echo "Waiting..."
#     wait

# done
