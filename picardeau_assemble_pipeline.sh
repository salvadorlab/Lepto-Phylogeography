#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N assemble_picardeau                                        
#PBS -l nodes=1:ppn=12 -l mem=10gb                                        
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

# ppath="/scratch/rx32940/Lepto_Work/picardeau_313"

# # assemble pair-end read seq

# cat $ppath/picardeau_313_biosamples.txt |\
# while read SAMN; 
#  do
#     echo "Starting command"
#     (
#     echo "$SAMN"
#     sapelo2_header="#!/bin/bash
#         #PBS -q batch                                                            
#         #PBS -N picardeau_asm_$SAMN                                        
#         #PBS -l nodes=1:ppn=24 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "

#     echo "$sapelo2_header" > ./sub_picardeau_asm.sh
#     echo "module load spades/3.12.0-k_245" >> ./sub_picardeau_asm.sh

#     echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
#     --pe1-1 $ppath/trimmed/${SAMN}_1_paired_trimmed.fastq.gz \
#     --pe1-2 $ppath/trimmed/${SAMN}_2_paired_trimmed.fastq.gz \
#     --careful --mismatch-correction \
#     -o $ppath/assemblies/$SAMN" >> ./sub_picardeau_asm.sh


#     qsub ./sub_picardeau_asm.sh
    
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


# QUASTPATH="/scratch/rx32940/Lepto_Work/picardeau_313" 
# refseq="/scratch/rx32940/reference"

# for file in /scratch/rx32940/Lepto_Work/picardeau_313/assemblies/*;
# do
#     biosample="$(basename "$file")"
#     species="$(python /home/rx32940/github/Lepto-Phylogeography/get_biosample_species.py "$biosample")" # get the species of the biosample acc
#     refname="$(ls "$refseq"/"$species"/*_genomic.fna)"
#     annotation="$(ls "$refseq"/"$species"/*_genomic.gff)"
    
#     quast.py \
#     $QUASTPATH/assemblies/$biosample/scaffolds.fasta \
#     --fragmented \
#     -r $refname \
#     -g $annotation \
#     -o $QUASTPATH/quast/$biosample/ \
#     -t 8 
# done


# ######################################################################
# #
# # multiqc
# # Aggregate all QUAST reports for the 50 biosamples with collection date 
# #
# # #####################################################################

# path_quast="/scratch/rx32940/Lepto_Work/picardeau_313" 

# module load MultiQC/1.5-foss-2016b-Python-2.7.14

# multiqc $path_quast/quast/*/report.tsv \
# -d -dd 1 -o $path_quast \
# -n quast_picardueau_313

#########################################################################
###  QUAST low mapping isolates with NCBI STAT identified reference genome
###########################################################################

# module load QUAST/5.0.2-foss-2018a-Python-2.7.14
# module load MultiQC/1.5-foss-2016b-Python-2.7.14

 
# QUASTPATH="/scratch/rx32940/Lepto_Work/picardeau_313" 
# refseq="/scratch/rx32940/reference"

# cat /scratch/rx32940/Lepto_Work/picardeau_313/low_map_isolates.txt |\
# while IFS="$(printf '\t')" read ACC SP;
# do
#     refname="$(ls "$refseq"/"$SP"/*_genomic.fna)"
#     annotation="$(ls "$refseq"/"$SP"/*_genomic.gff)"

#     quast.py \
#     $QUASTPATH/assemblies/$ACC/scaffolds.fasta \
#     --fragmented \
#     -r $refname \
#     -g $annotation \
#     -o $QUASTPATH/low_map_requast/$ACC \
#     -t 8

# done

# multiqc $QUASTPATH/low_map_requast/*/report.tsv \
# -d -dd 1 -o $QUASTPATH \
# -n low_map_requast_picardeau

#########################################################################
# BWA mem + Samtools for coverage
#########################################################################

module load SAMtools/1.10-GCC-8.2.0-2.31.1
module load BWA/0.7.17-foss-2016b
module load Anaconda3/2019.03
ml Qualimap2/2.2.1-foss-2016b-Java-1.8.0_144
module load MultiQC/1.5-foss-2016b-Python-2.7.14


ppath="/scratch/rx32940/Lepto_Work/picardeau_313"

cat $ppath/picardeau_313_biosamples.txt | 
while read SAMN;
do
    species="$(python /home/rx32940/github/Lepto-Phylogeography/get_biosample_species.py "$SAMN" "$ppath"/biosample_species_dict_picardeau_new.csv)"

    bwa mem -t 12 /scratch/rx32940/reference/$species/*_genomic.fna /scratch/rx32940/Lepto_Work/picardeau_313/trimmed/${SAMN}_1_paired_trimmed.fastq.gz /scratch/rx32940/Lepto_Work/picardeau_313/trimmed/${SAMN}_2_paired_trimmed.fastq.gz | samtools view -b - | samtools sort - > /scratch/rx32940/Lepto_Work/picardeau_313/bwa/$SAMN.sorted.bam

    qualimap bamqc -bam /scratch/rx32940/Lepto_Work/picardeau_313/bwa/$SAMN.sorted.bam -outdir /scratch/rx32940/Lepto_Work/picardeau_313/cov/$SAMN -nt 12
    # samtools index /scratch/rx32940/Lepto_Work/picardeau_313/bwa/$SAMN.sorted.bam

    # samtools coverage /scratch/rx32940/Lepto_Work/picardeau_313/bwa/$SAMN.sorted.bam -o /scratch/rx32940/Lepto_Work/picardeau_313/cov/${SAMN}_covstat.txt

done

multiqc /scratch/rx32940/Lepto_Work/picardeau_313/cov -o /scratch/rx32940/Lepto_Work/picardeau_313/ -n multiqc_qualimap_picardeau_313

########################################################################
#
# pagit - abacas for ordering contigs and polish
# reference can't take multifasta file, joined by join_reference_union.sh
# 
########################################################################

# module load PAGIT/1.64-foss-2016b
# module load Anaconda2/2019.03

# refseq="/scratch/rx32940/reference"
# outdir="/scratch/rx32940/Lepto_Work/picardeau_313/abacas"
# asmpath="/scratch/rx32940/Lepto_Work/picardeau_313/assemblies"

# for file in /scratch/rx32940/Lepto_Work/picardeau_313/assemblies/*;
# do  
#     biosample="$(basename "$file")"
#     species="$(python /home/rx32940/github/Lepto-Phylogeography/get_biosample_species.py "$biosample")" # get the species of the biosample acc
#     abacas.pl -r $refseq/$species/$species.union.fna -q $asmpath/$biosample/scaffolds.fasta -p nucmer -m -b -o $outdir/${biosample}_abacas
# done

