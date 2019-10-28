from Bio import Entrez

sra_uid = "/Users/rx32940/Dropbox/5. Rachel's projects/Phylogeography/bioprojects_uids.txt"
with open(sra_uid) as f:
    ids=f.read().split('\n')


Entrez.email = "rx32940@uga.edu"
handle = Entrez.efetch(db="bioproject",id=ids,rettype = "xml", retmode = "xml")

Entrez.read(handle,validate=False)