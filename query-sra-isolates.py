from Bio import Entrez

file = "/Users/rachel/Dropbox/5.Rachel-projects/Phylogeography/bioprojects_uids.txt"

with open(file) as f:
    ids = f.read().split("\n")

Entrez.email = "Your.Name.Here@example.org"
handle = Entrez.efetch(db="nucleotide",id=ids,retmode = "xml")

Entrez.read(handle,validate=False)