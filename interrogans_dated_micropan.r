library(micropan)
library(ggplot2)


setwd("/scratch/rx32940/pirate/interrogans_dated/micropan_interrogans/")
fasta_path <- "/scratch/rx32940/gubbins/dated_interrogans/fasta_dated_interrrogans"

interrogans_meta <- read.table("../dated_interrogans_metadata.csv", sep=",", header = TRUE) %>% select(c("BioSample.Accession","Genome.Name.x","Strain.x","BioProject.Accession.x","Genome.Length","Host.Name.x","group","country"))
test1 <- findGenes(file.path(fasta_path, "/SAMN13822336.fna")) # file.path suppose to be faster than paste(...,sep="/")

for (i in 1:nrow(interrogans_meta)){
    nuc_seq <- readFasta(file.path(fasta_path,str_c(interrogans_meta$BioSample.Accession[i],".fna")))
    findGenes(file.path(fasta_path,str_c(interrogans_meta$BioSample.Accession[i],".fna"))) %>% # produce annotated genome file gff
    filter(Score > 40) %>% # set cutoff for prodigal score as 40
    gff2fasta(nuc_seq)  %>% # convert gff to fasta  
    mutate(Sequence = translate(Sequence)) %>% # from nuc_seq to aa_seq 
    writeFasta(file.path("tmp", str_c(interrogans_meta$BioSample.Accession[i],".faa")))
}
 