from pandas import *
import os

df = read_csv('/scratch/rx32940/rest_sra_216/SC_34_isolates_98.csv',header = None)

SAMN_SRA_dict = df.set_index(1)[0].to_dict()

SRA_SAMN_dict = {v:k for k,v in SAMN_SRA_dict.items()}

dir_path = "/scratch/rx32940/rest_sra_216/assemblies/"

for dir in os.listdir(dir_path):
    SAMN_acc = SRA_SAMN_dict[dir]
    os.rename(dir_path+dir, dir_path + SAMN_acc)