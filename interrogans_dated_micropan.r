#  follow this tutorial: https://github.com/larssnip/micropan
library(micropan)
library(ggplot2)


setwd("/scratch/rx32940/pirate/interrogans_dated/micropan_interrogans/")
fasta_path <- "/scratch/rx32940/gubbins/dated_interrogans/fasta_dated_interrrogans"

# interrogans_meta <- read.table("../dated_interrogans_metadata.csv", sep=",", header = TRUE) %>%
#  select(c("BioSample.Accession","Genome.Name.x","Strain.x","BioProject.Accession.x","Genome.Length","Host.Name.x","group","country")) %>%
#  mutate(genome_id=str_c("GID",1:n())) # assign each genome a GID (must)


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
 
# faa.files <- list.files("faa",pattern="\\.faa$", full.names=T)
# # The BLAST E-value is the number of expected hits 
# # of similar quality (score) that could be found just by chance.
# # thus, the higher the e-value, the higher the possibility that two sequence are not related
# blastpAllAll(faa.files, out.folder="blast", verbose = T)
# # blast jobs terminated in the middle of running progress
# # find  /path/to/dest -type f -empty -delete # delete all empty files
# # reran blastpAllAll

# # list all blast files
# blast.files <- list.files("blast", pattern = "txt$", full.names = T)
# # find all self blast files
# self.tbl <- readBlastSelf(blast.files)
# # find all no-self alignments
# pair.tbl <- readBlastPair(blast.files)
# # compute distances between all proteins
# dst.tbl <- bDist(blast.tbl = bind_rows(self.tbl, pair.tbl))

# # store the distance matrix
# write.csv(dst.tbl, "all_protein_distance.csv",quote=FALSE,sep=",")

# # read the distance matrix into variable
# # identical proteins have distance = 0
# dst.tbl <- read.csv("all_protein_distance.csv")

# # plot a histogram of these distances, to get a picture of how similar the proteins tend to be
# fig3 <- ggplot(dst.tbl) +
#   geom_histogram(aes(x = Distance), bins = 100)
# # save the plot
# ggsave("prot_dist_distr.pdf",fig3)

# uses classical hierarchical clustering based on the distances
# complete linkage is the 'strictest' way of clustering, no distance between two members can exceed the threshold we specify.
# exact control of the 'radius' of our clusters the gene families
# specify a large threshold at .75
dst.tbl <- read.csv("all_protein_distance.csv")
clst.blast <- bClust(dst.tbl, linkage = "complete", threshold = 0.75)

# matrix with one row for each genome and one column for each gene cluster
panmat.blast <- panMatrix(clst.blast)

# plot the pan-matrix, how many clusters are found in 1,2,...,all genomes
panmatrix_plot <- tibble(Clusters = as.integer(table(factor(colSums(panmat.blast > 0),
                                          levels = 1:nrow(panmat.blast)))),
       Genomes = 1:nrow(panmat.blast)) %>% 
  ggplot(aes(x = Genomes, y = Clusters)) +
  geom_col() + labs(title = "Number of clusters found in 1, 2,...,all genomes")
  ggsave("ncluster_in_genomes.pdf",panmatrix_plot)

  # heaps fct estimatess the openness of the pangenome
  # pan-genome is closed if the estimated alpha is above 1.0
  heaps.est <- as.data.frame(heaps(panmat.blast, n.perm = 500))
  write.csv(heap.est,"pangenome_index_alpha.csv",quote=FALSE,sep=",",header=TRUE)

  # use fitting the binomial mixture models to estimate pangenomen size
  fitted <- binomixEstimate(panmat.blast)
  # inspecting the fitted BIC.tbl we can see how many mixture components is supported best by these data
  # component gene clusters into n categories (number of BIC compinent) with respect to how frequent they tend to occur in the genomes
  write.csv(as.data.frame(fitted$BIC.tbl),"BIC_gene_clusters.csv",quote=FALSE,sep=",",header=TRUE)




