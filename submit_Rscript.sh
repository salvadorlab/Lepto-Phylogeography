#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=fastBap_pirate
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=1             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/fastBap_pirate.%j.out       
#SBATCH --error=/scratch/rx32940/fastBap_pirate.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL  

ml Anaconda3/5.0.1
module load R-bundle-Bioconductor/3.10-foss-2019b

script_path="/home/rx32940/github/Lepto-Phylogeography"
Rscript $script_path/fastBAP.r > /scratch/rx32940/fastBap_pirate.log