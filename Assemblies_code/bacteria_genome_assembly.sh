#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N multiqc_cov                                       
#PBS -l nodes=1:ppn=2 -l mem=10gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

#####################################################################
# input: absolute path to the fastq seq
#        if need coverage output for each assembly, need to provide path to the reference genomes 
#           and species of each isolates
# output: absolute path for outdir
#            prokka need a separate output dir
# 
######################################################################

seqpath="/scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/PRJEB36553_4" 
outpath="/scratch/rx32940/All_Lepto_Assemblies/PRJEB36553_4"
prokkapath="/scratch/rx32940/core_gene_builder/prokka"
refpath="/scratch/rx32940/reference"

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

# mkdir $outpath/trimmed

# cat $outpath/all_biosamples.txt | \
# while read SRA;
# do
#     (
#         echo "$SRA"
#             sapelo2_header="#PBS -q batch\n#PBS -N asm_$SRA\n
#             #PBS -l nodes=1:ppn=24 -l mem=10gb\n
#             #PBS -l walltime=100:00:00\n
#             #PBS -M rx32940@uga.edu\n                                                  
#             #PBS -m abe\n                                                            
#             #PBS -o /scratch/rx32940\n                      
#             #PBS -e /scratch/rx32940\n                        
#             #PBS -j oe\n
#             "
    
#     echo -e $sapelo2_header > $outpath/qsub_trimseq.sh
#     echo "module load Trimmomatic/0.36-Java-1.8.0_144" >> $outpath/qsub_trimseq.sh


#     echo "java -jar /usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/trimmomatic-0.36.jar \
#     PE -threads 12 $seqpath/${SRA}_1.fastq.gz $seqpath/${SRA}_2.fastq.gz \
#     $outpath/trimmed/${SRA}_1_paired_trimmed.fastq.gz $outpath/trimmed/${SRA}_1_unpaired_trimmed.fastq.gz \
#     $outpath/trimmed/${SRA}_2_paired_trimmed.fastq.gz $outpath/trimmed/${SRA}_2_unpaired_trimmed.fastq.gz \
#     ILLUMINACLIP:/usr/local/apps/eb/Trimmomatic/0.36-Java-1.8.0_144/adapters/TruSeq3-PE.fa:2:30:10:2:keepBothReads \
#     LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36" >> $outpath/qsub_trimseq.sh

#     qsub $outpath/qsub_trimseq.sh

#     echo "submitted $SRA trimming"
#     ) &

#     echo "waiting"
#     wait
# done

############################################################################
#
# SPADES for pair end seq
# Assemble the trimmed seq 
#
############################################################################


# assemble pair-end read seq

# mkdir $outpath/assemblies

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


#     qsub $outpath/sub_spades_asm.sh
    
#     echo "$SAMN pair-end submitted"
#     ) &

#     echo "Waiting..."
#     wait

# done

######################################################################
#
# QUAST
# check the quality of each assemblies - not providing reference
#
######################################################################

# module load QUAST/5.0.2-foss-2018a-Python-2.7.14

# mkdir $outpath/quast

# for file in $outpath/assemblies/*;
# do
#     biosample="$(basename "$file")" 
    
#     quast.py \
#     $outpath/assemblies/$biosample/scaffolds.fasta \
#     --fragmented \
#     -o $outpath/quast/$biosample/ \
#     -t 12
# done

# ######################################################################
# #
# # multiqc
# # Aggregate all QUAST reports 
# #
# # #####################################################################

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $outpath/quast/*/report.tsv \
# -d -dd 1 -o $outpath \
# -n quast_results

#########################################################################
# BWA mem + Samtools for coverage 
# - this step is only available if reference species can be provided in a csv file
#   - need to specify which colname the species name is in (need who species name)
# - need python script get_biosample_species.py in the same folder
#########################################################################
# module load Anaconda3/2019.03


# mkdir $outpath/bwa

# cat $outpath/all_biosamples.txt | \
# while read SAMN;
# do
#     (
#     echo $SAMN

#     sapelo2_header="#PBS -q batch\n#PBS -N bwa_$SAMN\n
#     #PBS -l nodes=1:ppn=24 -l mem=10gb\n
#     #PBS -l walltime=100:00:00\n
#     #PBS -M rx32940@uga.edu\n                                                  
#     #PBS -m abe\n                                                            
#     #PBS -o /scratch/rx32940\n                      
#     #PBS -e /scratch/rx32940\n                        
#     #PBS -j oe\n"

#     echo -e $sapelo2_header > $outpath/qsub_qualimap.sh # -e so echo can interpret \n as line break

#     echo -e "module load SAMtools/1.10-GCC-8.2.0-2.31.1
#     module load BWA/0.7.17-foss-2016b
#     module load Anaconda3/2019.03
#     ml Qualimap2/2.2.1-foss-2016b-Java-1.8.0_144
#     module load MultiQC/1.5-foss-2016b-Python-2.7.14\n" >> $outpath/qsub_qualimap.sh

#     species="$(python /home/rx32940/github/Lepto-Phylogeography/Assemblies_code/get_biosample_species.py "$SAMN" "$outpath"/selfasm_sra_samn_species_4.csv 2)"

#     echo "$species"

#     echo "bwa mem -t 12 $refpath/$species/*_genomic.fna \
#     $outpath/trimmed/${SAMN}_1_paired_trimmed.fastq.gz \
#     $outpath/trimmed/${SAMN}_2_paired_trimmed.fastq.gz | \
#     samtools view -b - | \
#     samtools sort - > $outpath/bwa/$SAMN.sorted.bam" >> $outpath/qsub_qualimap.sh

#     echo "qualimap bamqc -bam $outpath/bwa/$SAMN.sorted.bam -outdir $outpath/cov/$SAMN -nt 12" >> $outpath/qsub_qualimap.sh
    
#     # cat $outpath/qsub_qualimap.sh
#     qsub $outpath/qsub_qualimap.sh
#     ) &

#     wait

#     echo "waiting"
# done

######################################################################
#
# multiqc
# Aggregate all qualimap output for coverage
#
# #####################################################################


module load MultiQC/1.5-foss-2016b-Python-2.7.14
multiqc $outpath/cov -o $outpath/ -n qualimap_cov_multiqc


##################################################################################
#
# PROKKA to annotate each assemblies, also produces GFF3 file for Roary input
#
##################################################################################

# # submit separate jobs fot self assembled assemblies 

# for asm in $outpath/assemblies/*;
# do
#     SAMN="$(basename "$asm")"
#     sapelo2_header="#!/bin/bash
#         #PBS -q highmem_q                                                            
#         #PBS -N prokka_$SAMN                                        
#         #PBS -l nodes=1:ppn=12 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "
#     (
#         echo "$sapelo2_header" > $outpath/qsub_prokka.sh
#         echo "module load prokka/1.13-foss-2016b-BioPerl-1.7.1" >> $outpath/qsub_prokka.sh


#         echo "prokka -kingdom Bacteria -outdir $prokkapath/$SAMN \
#         -genus Leptopsira -locustag $SAMN \
#         -prefix $SAMN \
#         $outpath/assemblies/$SAMN/scaffolds.fasta" >> $outpath/qsub_prokka.sh

#         qsub $outpath/qsub_prokka.sh 
    
#     ) &
    
#     wait
# done
