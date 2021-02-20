#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=beast_covid_rand500
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=8             
#SBATCH --time=100:00:00
#SBATCH --mem=100G
#SBATCH --output=/scratch/rx32940/beast_covid_rand500.%j.out       
#SBATCH --error=/scratch/rx32940/beast_covid_rand500.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL 

module load Beast/1.10.4-GCC-8.3.0

cd /scratch/rx32940/beast_covid_rand500/

beast -threads 8 /scratch/rx32940/beast_covid_rand500/rand_500_mafft.xml