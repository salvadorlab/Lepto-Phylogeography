#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=submit_prokka
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=1             
#SBATCH --time=100:00:00
#SBATCH --mem=10G
#SBATCH --output=/scratch/rx32940/submit_prokka.%j.out       
#SBATCH --error=/scratch/rx32940/submit_prokka.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL  

ncbi_path="/scratch/rx32940/pathogenic_sero/assemblies"
self_path="/scratch/rx32940/core_gene_builder/assemblies/Self_Assemblies_202003"
outdir="/scratch/rx32940/pathogenic_sero/prokka"


##################################################################################
#
# PROKKA to annotate each assemblies, also produces GFF3 file for Roary input
#
##################################################################################

# # submit separate jobs fot self assembled assemblies 

# for asm in $self_path/*;
# do
#     SAMN="$(basename "$asm" ".fasta")"
#     sapelo2_header="#!/bin/bash
#         #PBS -q highmem_q                                                            
#         #PBS -N prokka_$SAMN                                        
#         #PBS -l nodes=1:ppn=8 -l mem=10gb                                        
#         #PBS -l walltime=100:00:00                                                
#         #PBS -M rx32940@uga.edu                                                  
#         #PBS -m abe                                                              
#         #PBS -o /scratch/rx32940                        
#         #PBS -e /scratch/rx32940                        
#         #PBS -j oe
#     "
#     (
#         echo "$sapelo2_header" > ./qsub_prokka.sh
#         echo "module load prokka/1.13-foss-2016b-BioPerl-1.7.1" >> ./qsub_prokka.sh


#         echo "prokka -kingdom Bacteria -outdir $outdir/$SAMN \
#         -genus Leptopsira -locustag $SAMN \
#         -prefix $SAMN \
#         /scratch/rx32940/core_gene_builder/assemblies/Self_Assemblies_202003/$SAMN.fasta" >> ./qsub_prokka.sh

#         qsub ./qsub_prokka.sh 
    
#     ) &
    
#     wait
# done

# # submit separate jobs for ncbi downloaded assemblies

for asm in $ncbi_path/*;
do
    SAMN="$(basename "$asm" ".fna")"
    sapelo2_header="#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=${SAMN}_prokka_sero
#SBATCH --ntasks=1                    	
#SBATCH --cpus-per-task=2             
#SBATCH --time=100:00:00
#SBATCH --mem=20G
#SBATCH --output=/scratch/rx32940/${SAMN}_prokka_sero.%j.out       
#SBATCH --error=/scratch/rx32940/${SAMN}_prokka_sero.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL  
    "
    (
        echo "$sapelo2_header" > ./qsub_prokka.sh
        echo "module load prokka/1.14.5-gompi-2019b" >> ./qsub_prokka.sh


        echo "prokka -kingdom Bacteria -outdir $outdir/$SAMN \
        -genus Leptopsira -locustag $SAMN \
        -prefix $SAMN \
        --force \
        /scratch/rx32940/pathogenic_sero/assemblies/$SAMN.fna" >> ./qsub_prokka.sh

        sbatch ./qsub_prokka.sh 
    
    ) &
    
    wait
done

##################################################################################
#
# Roary to identify core genes
#
##################################################################################

# module load Roary/3.12.0

# test with only interrogans species
# roary -e -n -p 12 /scratch/rx32940/core_gene_builder/species_gff/adleri/*.gff -v -f /scratch/rx32940/core_gene_builder/roary/adleri/

# create pangenome with roary including the outgroup
# roary -e -p 24 -f /scratch/rx32940/core_gene_builder/roary/include_outgroup /scratch/rx32940/core_gene_builder/filtered_gff/*.gff -v
