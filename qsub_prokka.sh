#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=SAMN16295713_prokka_sero
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=2             
#SBATCH --time=100:00:00
#SBATCH --mem=20G
#SBATCH --output=/scratch/rx32940/SAMN16295713_prokka_sero.%j.out       
#SBATCH --error=/scratch/rx32940/SAMN16295713_prokka_sero.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL  
    
module load prokka/1.14.5-gompi-2019b
prokka -kingdom Bacteria -outdir /scratch/rx32940/pathogenic_sero/prokka/SAMN16295713         -genus Leptopsira -locustag SAMN16295713         -prefix SAMN16295713         --force         /scratch/rx32940/pathogenic_sero/assemblies/SAMN16295713.fna
