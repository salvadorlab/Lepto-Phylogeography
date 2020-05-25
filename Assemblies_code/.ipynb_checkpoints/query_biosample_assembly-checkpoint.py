from pandas import *
import os

df = read_csv('/scratch/rx32940/PATRIC_biosample_assemblies.csv',header = None) # read from csv, assembly as index

#df = df.parse(xls.sheet_names[0], index_col = 1) # parse the first sheet of excel with row name = 1

df.iloc[:,1] = df.iloc[:,1].str[:13] # substring the version from the assembly accession
df.iloc[:,1] = [item.replace("GCF","GCA") for item in df.iloc[:,1]] # replace all refseq accession with genebank acc
print(df)
biosample_assembly = df.set_index(1)[0].to_dict() # set assembly as index, biosample as point to
#print(biosample_assembly)


path = "/scratch/rx32940/PATRIC_assemblies_633/ncbi-genomes-2020-01-22/"

for f in os.listdir(path):
    assembly = f[0:f.index(".")]
    biosample_name = biosample_assembly[assembly]
    os.rename(path+f,path+biosample_name + ".fna.gz")
    #print(biosample_name)



