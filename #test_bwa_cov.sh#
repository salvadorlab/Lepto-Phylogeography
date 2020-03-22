#!/bin/bash
#PBS -q highmem_q                                                            
#PBS -N test_bwa_samtools                                        
#PBS -l nodes=1:ppn=1 -l mem=50gb                                        
#PBS -l walltime=100:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

module load SAMtools/1.10-GCC-8.2.0-2.31.1
module load BWA/0.7.17-foss-2016b


bwa mem /scratch/rx32940/reference/mtsangambouensis/GCF_004770475.1_ASM477047v1_genomic.fna /scratch/rx32940/Lepto_Work/picardeau_313/trimmed/SAMEA5168075_1_paired_trimmed.fastq.gz /scratch/rx32940/Lepto_Work/picardeau_313/trimmed/SAMEA5168075_2_paired_trimmed.fastq.gz | samtools view -b - | samtools sort - > /scratch/rx32940/Lepto_Work/picardeau_313/bwa/SAMEA5168075.sorted.bam

samtools index /scratch/rx32940/Lepto_Work/picardeau_313/bwa/SAMEA5168075.sorted.bam

samtools coverage /scratch/rx32940/Lepto_Work/picardeau_313/bwa/SAMEA5168075.sorted.bam -o /scratch/rx32940/Lepto_Work/picardeau_313/cov/SAMEA5168075_covstat.txt
