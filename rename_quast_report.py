import os

path = "/scratch/rx32940/All_Lepto_Assemblies/PATRIC_assemblies_633/quast_assemblies/"

for dir in os.listdir(path):
    dir_name = str(dir)
    os.rename(path + dir+"/report.tsv", path + dir+ "/" + dir + ".tsv")
    