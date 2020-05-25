import os
import os.path
from os import path

asm_path = "/scratch/rx32940/Lepto_Work/rest_211/assemblies/"

true = 0
false = 0
for dir in os.listdir(asm_path):
    dir_name = str(dir)
    if(path.exists(asm_path+ dir+"/scaffolds.fasta")):
        os.rename(asm_path+ dir+"/scaffolds.fasta", asm_path + dir+ "/" + dir + ".fasta")

