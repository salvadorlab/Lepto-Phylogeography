import os

path = "/scratch/rx32940/All_Lepto_Assemblies/dated_assembled_51/quast_assemblies/"

for dir in os.listdir(path):
    dir_name = str(dir)
    os.rename(path + dir+"/transposed_report.tsv", path + dir+ "/" + dir + ".tsv")
    