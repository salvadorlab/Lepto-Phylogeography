#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=treeWAS_snps
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=1             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/treeWAS_snps.%j.out       
#SBATCH --error=/scratch/rx32940/treeWAS_snps.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL  

ml Anaconda3/5.0.1
module load R-bundle-Bioconductor/3.10-foss-2019b

script_path="/home/rx32940/github/Lepto-Phylogeography"
Rscript $script_path/treeWAS_snps.r > /scratch/rx32940/treeWAS_snps.log