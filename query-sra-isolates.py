From Bio import Entrez

Entrez.email = "Your.Name.Here@example.org"
handle = Entrez.efetch(db="bioproject",id="",rettype = "xml", retmode = "xml")

Entrez.read(handle)