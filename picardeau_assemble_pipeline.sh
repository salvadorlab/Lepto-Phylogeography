#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_picardeau                                        
#PBS -l nodes=1:ppn=1 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

###################################################################
#
# fastq files with runs (pair-end)
# quality check
#
####################################################################

# seqpath="/scratch/rx32940/picardeau/SRA_seq"
# outpath="/scratch/rx32940/Lepto_Work/picardeau_313/fastqc"

# module load FastQC/0.11.8-Java-1.8.0_144

# all_files=$(ls -d "$seqpath"/*) # list absolute path of all files in the dir

# # do fastqc for all 313 * 2 runs Forward and Reverse at once
# fastqc -t 12 -o fastqc -o $outpath -f fastq $all_files 

######################################################################
#
# multiqc
# Aggregate all fastqc reports for the 51 biosamples with collection date 
#
# #####################################################################

# path_qc="/scratch/rx32940/Lepto_Work/picardeau_313/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# 
############################################################################

# seqpath="/scratch/rx32940/picardeau/SRA_seq"
# ppath="/scratch/rx32940/Lepto_Work/picardeau_313"

# module load Trimmomatic/0.36-Java-1.8.0_144

# paste $ppath/picardeau_313_sra.txt $ppath/picardeau_313_biosamples.txt |\
# while IFS="$(printf '\t')" read SRA SAMN; 
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 24 $seqpath/${SRA}_1.fastq.gz $seqpath/${SRA}_2.fastq.gz \
#     $ppath/trimmed/${SAMN}_1_paired_trimmed.fastq.gz $ppath/trimmed/${SAMN}_1_unpaired_trimmed.fastq.gz \
#     $ppath/trimmed/${SAMN}_2_paired_trimmed.fastq.gz $ppath/trimmed/${SAMN}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

############################################################################
#
# SPADES for pair end seq
# Assemble the trimmed seq 
#
############################################################################

ppath="/scratch/rx32940/Lepto_Work/picardeau_313"

# assemble pair-end read seq

cat $ppath/picardeau_313_biosamples.txt |\
while read SAMN; 
 do
    echo "Starting command"
    (
    echo "$SAMN"
    sapelo2_header="#!/bin/bash
        #PBS -q batch                                                            
        #PBS -N picardeau_asm_$SAMN                                        
        #PBS -l nodes=1:ppn=24 -l mem=10gb                                        
        #PBS -l walltime=100:00:00                                                
        #PBS -M rx32940@uga.edu                                                  
        #PBS -m abe                                                              
        #PBS -o /scratch/rx32940                        
        #PBS -e /scratch/rx32940                        
        #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub_picardeau_asm.sh
    echo "module load spades/3.12.0-k_245" >> ./sub_picardeau_asm.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    --pe1-1 $ppath/trimmed/${SAMN}_1_paired_trimmed.fastq.gz \
    --pe1-2 $ppath/trimmed/${SAMN}_2_paired_trimmed.fastq.gz \
    --careful --mismatch-correction \
    -o $ppath/assemblies/$SAMN" >> ./sub_picardeau_asm.sh


    qsub ./sub_picardeau_asm.sh
    
    echo "$SAMN pair-end submitted"
    ) &

    echo "Waiting..."
    wait

done

