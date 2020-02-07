#!/bin/bash
    #PBS -q batch                                                         
    #PBS -N rest216_SAMN07502166                                         
    #PBS -l nodes=1:ppn=4 -l mem=100gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/                    
    #PBS -e /scratch/rx32940/                        
    #PBS -j oe
    
module load spades/3.12.0-k_245
python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py     --restart-from ec --careful --mismatch-correction     -o /scratch/rx32940/All_Lepto_Assemblies/rest_sra_216/assemblies/SAMN07502166
