#!/bin/bash
#PBS -q bahl_salv_q                                                          
#PBS -N fastGear                                      
#PBS -l nodes=1:ppn=24 -l mem=50gb                                        
#PBS -l walltime=500:00:00                                                
#PBS -M rx32940@uga.edu                                                  
#PBS -m abe                                                              
#PBS -o /scratch/rx32940                        
#PBS -e /scratch/rx32940                        
#PBS -j oe

software_path="/home/rx32940/fastGEARpackageLinux64bit"
# need to install MCR interactive instead of silent 
# change installation destination folder
matlab_path="/home/rx32940/MATLAB/v901" 
file_path="/scratch/rx32940/pirate/interrogans_dated"

$software_path/run_fastGEAR.sh $matlab_path \
$file_path/interrogans_out/core_alignment.fasta \
$file_path/fastgear_interrogans/interrogans_dated.mat \
$software_path/fG_input_specs.txt