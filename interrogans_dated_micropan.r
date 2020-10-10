#  follow this tutorial: https://github.com/larssnip/micropan
library(micropan)
library(ggplot2)


setwd("/scratch/rx32940/pirate/interrogans_dated/micropan_interrogans/")
fasta_path <- "/scratch/rx32940/gubbins/dated_interrogans/fasta_dated_interrrogans"

interrogans_meta <- read.table("../dated_interrogans_metadata.csv", sep=",", header = TRUE) %>%
 select(c("BioSample.Accession","Genome.Name.x","Strain.x","BioProject.Accession.x","Genome.Length","Host.Name.x","group","country")) %>%
 mutate(genome_id=str_c("GID",1:n())) # assign each genome a GID (must)


# # find genes of each genome with prodigal
# # set cutoff score at 40 to get rid of low scoring gene
# # translate nucleotide sequences to amino acid sequences
# # write the faa file 
# for (i in 1:nrow(interrogans_meta)){
#     nuc_seq <- readFasta(file.path(fasta_path,str_c(interrogans_meta$BioSample.Accession[i],".fna")))
#     findGenes(file.path(fasta_path,str_c(interrogans_meta$BioSample.Accession[i],".fna"))) %>% # produce annotated genome file gff
#     filter(Score > 40) %>% # set cutoff for prodigal score as 40
#     gff2fasta(nuc_seq)  %>% # convert gff to fasta  
#     mutate(Sequence = translate(Sequence)) %>% # from nuc_seq to aa_seq 
#     writeFasta(file.path("tmp", str_c(interrogans_meta$genome_id[i],".faa")))
# }

# prepare the faa files into the right format for following analysis
# add biosample id to each gene's sequence and their seqID
# ex. header = SAMN06434252_seq1 Seqid=CP022883.1 MKIKVNTSEFLKAIHAVEGVI...
# dir.create("faa")
# for(i in 1:nrow(interrogans_meta)){
#     panPrep(file.path("tmp",str_c(interrogans_meta$genome_id[i],".faa")),
#     interrogans_meta$genome_id[i],
#     file.path("faa",str_c(interrogans_meta$genome_id[i],".faa")))
# }
#  dir.create("blast")
 
faa.files <- list.files("faa",pattern="\\.faa$", full.names=T)
# The BLAST E-value is the number of expected hits 
# of similar quality (score) that could be found just by chance.
# thus, the higher the e-value, the higher the possibility that two sequence are not related
blastpAllAll(faa.files, out.folder="blast", verbose = T)
# blast jobs terminated in the middle of running progress
# find  /path/to/dest -type f -empty -delete # delete all empty files
# reran blastpAllAll

# list all blast files
blast.files <- list.files("blast", pattern = "txt$", full.names = T)
# find all self blast files
self.tbl <- readBlastSelf(blast.files)
# find all no-self alignments
pair.tbl <- readBlastPair(blast.files)
# compute distances between all proteins
dst.tbl <- bDist(blast.tbl = bind_rows(self.tbl, pair.tbl))

save(dst.tbl, "all_protein_distance.RData")

