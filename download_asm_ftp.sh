#!/bin/bash


asm_path="/scratch/rx32940/All_Lepto_Assemblies"
cat $asm_path/353_asm_ftp_GB.txt |
while read ftp;
    do

        wget -P $asm_path/Dated_ASM_052620 --no-verbose -nH --cut-dirs=6 --recursive $ftp

    done