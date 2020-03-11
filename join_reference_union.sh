#!/bin/bash

# reference file joined for PAGIT ABACAS 
# this file produce a union reference file and a split info file

for file in /scratch/rx32940/reference/*;
do
species="$(basename "$file")"
cd $file
perl /home/rx32940/PAGIT/ABACAS/joinMultifasta.pl *.fna $species.union.fna
done