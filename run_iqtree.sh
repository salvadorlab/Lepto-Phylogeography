#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=fastGear_maskedSNP_iqtree
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=10             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/fastGear_maskedSNP_iqtree.%j.out       
#SBATCH --error=/scratch/rx32940/fastGear_maskedSNP_iqtree.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

module load IQ-TREE/1.6.5-omp

# use MFP: model finder to find the right substitution model
# -nt AUTO, detects best number of cores to use
iqtree -nt AUTO -m MFP+ASC \
-pre /scratch/rx32940/all_interrogans_dated/fastgear/fastGear_iqtree/all_int_dated_core_mask_snps \
-s /scratch/rx32940/all_interrogans_dated/fastgear/all_int_dated_core_mask_snps.fasta
