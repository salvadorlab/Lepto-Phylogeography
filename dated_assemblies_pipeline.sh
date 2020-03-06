#!/bin/bash
#PBS -q bahl_salv_q                                                            
#PBS -N assemble_dated32                                        
#PBS -l nodes=1:ppn=1 -l mem=10gb                                        
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

# seqpath="/scratch/rx32940/merged_runs"
# path_qc="/scratch/rx32940/Lepto_Work/dated_32/fastqc" 

# module load FastQC/0.11.8-Java-1.8.0_144

# single_files=$(ls -d "$seqpath"/single/*) # list absolute path of all files in the dir

# fastqc -t 12 -o fastqc -o $path_qc -f fastq $single_files # do fastqc for single end reads

# pair_files=$(cat "$seqpath"/pair_nonSree.txt) # do fastqc for pair end reads (excluding sree's isolates)

# fastqc -t 12 -o fastqc -o $path_qc -f fastq $pair_files

# ######################################################################
# #
# # multiqc
# # Aggregate all fastqc reports for the 51 biosamples with collection date 
# #
# # #####################################################################

# path_qc="/scratch/rx32940/Lepto_Work/dated_32/fastqc" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_qc/*_fastqc.zip -o $path_qc

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# 
############################################################################


# module load Trimmomatic/0.36-Java-1.8.0_144

# # trim single end files
# path_seq="/scratch/rx32940/merged_runs"
# output_dir="/scratch/rx32940/Lepto_Work/dated_32/trimmed"

# for fastq in $path_seq/single/*;
# do
#     biosample=$(basename "$fastq" .fastq.gz)
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     SE -threads 12 $path_seq/single/$biosample.fastq.gz $output_dir/single/${biosample}_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

# cat $path_seq/pair_nonSree_SAMN.txt | \
# while read biosample;
# do  
#     java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $path_seq/pair/${biosample}_1.fastq.gz $path_seq/pair/${biosample}_2.fastq.gz \
#     $output_dir/pair/${biosample}_1_paired_trimmed.fastq.gz $output_dir/pair/${biosample}_1_unpaired_trimmed.fastq.gz \
#     $output_dir/pair/${biosample}_2_paired_trimmed.fastq.gz $output_dir/pair/${biosample}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
# done

############################################################################
#
# SPADES for single end seq
# Assemble the trimmed seq 
#
############################################################################

path_seq="/scratch/rx32940/merged_runs"
trim_seq="/scratch/rx32940/Lepto_Work/dated_32/trimmed"

assemble single-end read seq
cat $path_seq/single.txt |\

 while read SAMN; 
 do
    echo "Starting command"
    (
    echo "$SAMN"
    sapelo2_header="#!/bin/bash
        #PBS -q bahl_salv_q                                                            
        #PBS -N assemble32_single_$SAMN                                        
        #PBS -l nodes=1:ppn=12 -l mem=10gb                                        
        #PBS -l walltime=100:00:00                                                
        #PBS -M rx32940@uga.edu                                                  
        #PBS -m abe                                                              
        #PBS -o /scratch/rx32940                        
        #PBS -e /scratch/rx32940                        
        #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub_assemble32_single.sh
    echo "module load spades/3.12.0-k_245" >> ./sub_assemble32_single.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    --s1 $trim_seq/single/${SAMN}_trimmed.fastq.gz \
    --careful --mismatch-correction \
    -o /scratch/rx32940/Lepto_Work/dated_32/assemblies/$SAMN" >> ./sub_assemble32_single.sh


    qsub ./sub_assemble32_single.sh
    
    echo "$SAMN single-end submitted"
    ) &

    echo "Waiting..."
    wait

done

###################################################################

# assemble pair-end read seq

cat $path_seq/pair_nonSree_SAMN.txt |\

 while read SAMN; 
 do
    echo "Starting command"
    (
    echo "$SAMN"
    sapelo2_header="#!/bin/bash
        #PBS -q bahl_salv_q                                                            
        #PBS -N assemble32_pair_$SAMN                                        
        #PBS -l nodes=1:ppn=12 -l mem=10gb                                        
        #PBS -l walltime=100:00:00                                                
        #PBS -M rx32940@uga.edu                                                  
        #PBS -m abe                                                              
        #PBS -o /scratch/rx32940                        
        #PBS -e /scratch/rx32940                        
        #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub_assemble32_pair.sh
    echo "module load spades/3.12.0-k_245" >> ./sub_assemble32_pair.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    --pe1-1 $trim_seq/pair/${SAMN}_1_paired_trimmed.fastq.gz \
    --pe1-2 $trim_seq/pair/${SAMN}_2_paired_trimmed.fastq.gz \
    --careful --mismatch-correction \
    -o /scratch/rx32940/Lepto_Work/dated_32/assemblies/$SAMN" >> ./sub_assemble32_pair.sh


    qsub ./sub_assemble32_pair.sh
    
    echo "$SAMN pair-end submitted"
    ) &

    echo "Waiting..."
    wait

done

######################################################################
#
# QUAST
# check the quality of each assemblies
#
######################################################################

# module load QUAST/5.0.2-foss-2018a-Python-2.7.14

# QUASTPATH="/scratch/rx32940" 

# # quast with interrogans Lai reference genome ASM9256v1
# cat $QUASTPATH/All_Lepto_Assemblies/sree_18/interrogans.txt | xargs -I{} quast.py \
# $QUASTPATH/All_Lepto_Assemblies/sree_18/assemblies/{}.fna.gz \
# -o $QUASTPATH/All_Lepto_Assemblies/sree_18/quast/{}/ \
# -r $QUASTPATH/reference/interrogans/GCF_000092565.1_ASM9256v1_genomic.fna \
# -g $QUASTPATH/reference/interrogans/GCF_000092565.1_ASM9256v1_genomic.gff
# -t 8 

# # quast with interrogans Lai reference genome ASM1394v1
# cat $QUASTPATH/All_Lepto_Assemblies/sree_18/borgpetersenii.txt | xargs -I{} quast.py \
# $QUASTPATH/All_Lepto_Assemblies/sree_18/assemblies/{}.fna.gz \
# -o $QUASTPATH/All_Lepto_Assemblies/sree_18/quast/{}/ \
# -r $QUASTPATH/reference/borgpetersenii/GCF_000013945.1_ASM1394v1_genomic.fna \
# -g $QUASTPATH/reference/borgpetersenii/GCF_000013945.1_ASM1394v1_genomic.gff
# -t 8 

######################################################################
#
# multiqc
# Aggregate all QUAST reports for the 50 biosamples with collection date 
#
# #####################################################################

# path_quast="/scratch/rx32940/Lepto_Work" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_quast/quast/*/report.tsv \
# -d -dd 1 -o $path_quast \
# -n QC_self_asm_date_32

########################################################################
#
# Pilon
# for post assembly polishing
# do qlogin for one of the genomes first, then do quast comparison
# need assembly fasta and bam map to reference
# 
########################################################################

# module load pilon/1.22-Java-1.8.0_144

# https://github.com/broadinstitute/pilon/wiki
