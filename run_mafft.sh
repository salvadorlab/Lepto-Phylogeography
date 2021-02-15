#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=mafft_covid500
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=10             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/default_mafft_covid500random.%j.out       
#SBATCH --error=/scratch/rx32940/default_mafft_covid500random.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

module load MAFFT/7.470-GCC-8.3.0-with-extensions

data_path="/home/rx32940/github/washingtonCountiesCovid19/data/rawData/GeneticData"
mafft $data_path/gisaid_hcov-19_2021_02_15_17.fasta > $data_path/covid_random500_alignment02152021.fasta 