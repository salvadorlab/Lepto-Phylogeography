#!/bin/bash

SRA_PATH="/scratch/rx32940"
# cat $SRA_PATH/picardeau/picardeau_313_sra.txt | xargs - I python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
# -o $SRA_PATH/picardeau/assemblies/{} \
# --pe1-1 $SRA_PATH/picardeau/SRA_seq/{}_1.fastq.gz
# --pe1-2 $SRA_PATH/picardeau/SRA_seq/{}_2.fastq.gz

paste $SRA_PATH/rest_sra_216/PairEnd_4.txt |\
 while read SRA; 
 do
    echo "Starting command"
    (
    echo "$SRA"
    sapelo2_header="#!/bin/bash
    #PBS -q batch                                                            
    #PBS -N assemble_$SRA                                         
    #PBS -l nodes=1:ppn=8 -l mem=100gb                                        
    #PBS -l walltime=10:00:00                                                
    #PBS -M rx32940@uga.edu                                                  
    #PBS -m abe                                                              
    #PBS -o /scratch/rx32940/rest_sra_216                        
    #PBS -e /scratch/rx32940/rest_sra_216                        
    #PBS -j oe
    "

    echo "$sapelo2_header" > ./sub.sh
    echo "module load spades/3.12.0-k_245" >> ./sub.sh

    echo "python /usr/local/apps/gb/spades/3.12.0-k_245/bin/spades.py \
    -o $SRA_PATH/rest_sra_216/assemblies/$SRA \
    --pe1-1 $SRA_PATH/rest_sra_216/SRAseq/${SRA}_1.fastq.gz \
    --pe1-2 $SRA_PATH/rest_sra_216/SRAseq/${SRA}_4.fastq.gz" >> ./sub.sh

    qsub ./sub.sh
    
    echo "$SRA submitted"
    ) &

    echo "Waiting..."
    wait

done


