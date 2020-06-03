#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N trim_4                                       
#PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

#####################################################################
# input: absolute path to the fastq seq
# output: absolute path for outdir, need to mkdir first
######################################################################

seqpath="/scratch/rx32940/rest_sra_216/PRJEB36553_4" 
outpath="/scratch/rx32940/All_Lepto_Assemblies/PRJEB36553_4"

all_fastq="$(ls "$seqpath"/*)" # list all fastq in the dir
# extract all the unique names from fastq dir into a file, find "_", print the first part, return unique values
ls $seqpath | awk -F'_' '{print $1}' | uniq > $outpath/all_biosamples.txt # basename don't fo linewise operations

###################################################################
#
# fastqc 
# quality check
# pair end reads
#
####################################################################


# module load FastQC/0.11.8-Java-1.8.0_144

# mkdir $outpath/fastqc

# fastqc -t 12 -o $outpath/fastqc -f fastq $all_fastq

######################################################################
#
# multiqc
# Aggregate all fastqc reports 
#
# #####################################################################


# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $outpath/fastqc/*_fastqc.zip -o $outpath

############################################################################
# 
# trimming 
# Trimmomatic
# single end and pair end fastq files need to trim separately with separate adapters
# 
############################################################################

mkdir $outpath/trimmed

cat $outpath/all_biosamples.txt | \
while read SRA;
do
    (
        echo "$SRA"
            sapelo2_header="#PBS -q batch\n#PBS -N asm_$SRA\n
            #PBS -l nodes=1:ppn=24 -l mem=10gb\n
            #PBS -l walltime=100:00:00\n
            #PBS -M rx32940@uga.edu\n                                                  
            #PBS -m abe\n                                                            
            #PBS -o /scratch/rx32940\n                      
            #PBS -e /scratch/rx32940\n                        
            #PBS -j oe\n
            "
    
    echo -e $sapelo2_header > $outpath/qsub_trimseq.sh
    echo "module load Trimmomatic/0.36-Java-1.8.0_144" >> $outpath/qsub_trimseq.sh


    echo "java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
    PE -threads 12 $seqpath/${SRA}_1.fastq.gz $seqpath/${SRA}_2.fastq.gz \
    $outpath/trimmed/${SRA}_1_paired_trimmed.fastq.gz $outpath/trimmed/${SRA}_1_unpaired_trimmed.fastq.gz \
    $outpath/trimmed/${SRA}_2_paired_trimmed.fastq.gz $outpath/trimmed/${SRA}_2_unpaired_trimmed.fastq.gz \
    ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> $outpath/qsub_trimseq.sh

    qsub $outpath/qsub_trimseq.sh

    echo "submitted $SRA trimming"
    ) &

    echo "waiting"
    wait
done

############################################################################
#
# SPADES for pair end seq
# Assemble the trimmed seq 
#
############################################################################


# assemble pair-end read seq

# cat $outpath/all_biosamples.txt |\
# while read SAMN; 
#  do
#     echo "Starting command"
#     (
#     echo "$SAMN"
#     sapelo2_header="#!/bin/bash
#         #PBS -q batch                                                            
#         #PBS -N asm_$SAMN                                        
#         #PBS -l nodes=1:ppn=24 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "

#     echo "$sapelo2_header" > $outpath/sub_spades_asm.sh
#     echo "module load spades/3.12.0-k_245" >> $outpath/sub_spades_asm.sh

#     echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
#     --pe1-1 $outpath/trimmed/${SAMN}_1_paired_trimmed.fastq.gz \
#     --pe1-2 $outpath/trimmed/${SAMN}_2_paired_trimmed.fastq.gz \
#     --careful --mismatch-correction \
#     -o $outpath/assemblies/$SAMN" >> $outpath/sub_spades_asm.sh


#     qsub ./sub_spades_asm.sh
    
#     echo "$SAMN pair-end submitted"
#     ) &

#     echo "Waiting..."
#     wait

# done