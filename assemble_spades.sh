#!/bin/bash

SRA_PATH="/scratch/rx32940"
# cat $SRA_PATH/picardeau/picardeau_313_sra.txt | xargs - I python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
# -o $SRA_PATH/picardeau/assemblies/{} \
# --pe1-1 $SRA_PATH/picardeau/SRA_seq/{}_1.fastq.gz
# --pe1-2 $SRA_PATH/picardeau/SRA_seq/{}_2.fastq.gz

paste $SRA_PATH/picardeau/picardeau_313_sra_2.txt $SRA_PATH/picardeau/picardeau_313_biosamples_2.txt |\
 while IFS="$(printf '\t')" read SRA SAMN; 
 do
    echo "Starting command"
    (
    echo "$SRA,  $SAMN"
    sapelo2_header="#!/bin/bash
    #PBS -q highmem_q                                                            
    #PBS -N assemble_$SAMN                                         
    #PBS -l nodes=1:ppn=4 -l mem=200gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940                        
    #PBS -e /scratch/rx32940                        
    #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub.sh
    echo "module load spades/3.12.0-k_245" >> ./sub.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    -o $SRA_PATH/picardeau/assemblies/$SAMN \
    --pe1-1 $SRA_PATH/picardeau/SRA_seq/${SRA}_1.fastq.gz \
    --pe1-2 $SRA_PATH/picardeau/SRA_seq/${SRA}_2.fastq.gz" >> ./sub.sh

    qsub ./sub.sh
    
    echo "$SAMN submitted"
    ) &

    echo "Waiting..."
    wait

done


