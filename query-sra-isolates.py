from Bio import Entrez

sra_uid = "/Users/rx32940/Dropbox/5.Rachel-projects/Phylogeography/bioprojects_uids.txt"

with open(sra_uid) as f:
    ids= f.read().split('\n')

ids = [int(i) for i in ids]

Entrez.email = "rx32940@uga.edu"
handle = Entrez.esummary(db="bioproject",id=477299,retmode="xml",rettype="xml")

results = Entrez.read(handle,validate=False)

print(results)
