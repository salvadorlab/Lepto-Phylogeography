#!/bin/bash

SRA_PATH="/scratch/rx32940"
# cat $SRA_PATH/picardeau/picardeau_313_sra.txt | xargs - I python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
# -o $SRA_PATH/picardeau/assemblies/{} \
# --pe1-1 $SRA_PATH/picardeau/SRA_seq/{}_1.fastq.gz
# --pe1-2 $SRA_PATH/picardeau/SRA_seq/{}_2.fastq.gz

cat $SRA_PATH/All_Lepto_Assemblies/picardeau_313/remaining_biosamples.txt |\
 while read SAMN; 
 do
    echo "Starting command"
    (
    echo "$SAMN"
    sapelo2_header="#!/bin/bash
    #PBS -q bahl_salv_q                                                         
    #PBS -N rest216_$SAMN                                         
    #PBS -l nodes=1:ppn=4 -l mem=10gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/                    
    #PBS -e /scratch/rx32940/                        
    #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub.sh
    echo "module load spades/3.12.0-k_245" >> ./sub.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    --restart-from ec --careful --mismatch-correction \
    -o $SRA_PATH/All_Lepto_Assemblies/picardeau_313/assemblies/$SAMN" >> ./sub.sh

    qsub ./sub.sh
    
    echo "$SAMN restart submitted"
    ) &

    echo "Waiting..."
    wait

done


