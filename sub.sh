#!/bin/bash

    #PBS -q bahl_salv_q                                                         
    #PBS -N rest216_SAMN11389095                                         
    #PBS -l nodes=1:ppn=4 -l mem=10gb                                        

    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/                    
    #PBS -e /scratch/rx32940/                        
    #PBS -j oe
    
module load spades/3.12.0-k_245
python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py     --restart-from ec --careful --mismatch-correction     -o /scratch/rx32940/Lepto_Work/assemblies/SAMN11389095
