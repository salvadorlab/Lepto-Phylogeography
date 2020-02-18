from pandas import *
import os

df = read_csv('/scratch/rx32940/dated51_PE_sra_SAMN.csv',header = None)

SAMN_SRA_dict = df.set_index(1)[0].to_dict()

SRA_SAMN_dict = {v:k for k,v in SAMN_SRA_dict.items()}

dir_path = "/scratch/rx32940/merged_runs/"

for dir in os.listdir(dir_path):

    if '_' in dir:
        key = dir[:-11]
        if key not in SRA_SAMN_dict:
            print("None")
        else:
            SAMN_acc = SRA_SAMN_dict[key]
            fr = dir[11:-9]
            new_name = dir_path + SAMN_acc + "_" + fr + ".fastq.gz"
            os.rename(dir_path+dir, new_name)