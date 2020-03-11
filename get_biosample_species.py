import csv 
import sys
import pandas as pd

# read in csv into dict, query from bash, return species name to bash
# work with picardeau_assemble_pipeline

biosample=sys.argv[0]
data = pd.read_csv("/scratch/rx32940/Lepto_Work/picardeau_313/biosample_species_dict_picardeau.csv",header=None, sep=",",index_col=0)
species_dict = data.to_dict()[1]
dir_name=str(species_dict[biosample].split(" ")[1])
sys.exit(dir_name)

