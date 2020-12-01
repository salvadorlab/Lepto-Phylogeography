library(dplyr)
library(reshape2)
library(plyr)
library(plotly)
library(fastbaps, lib.loc="/home/rx32940/Rlibs")
library(ape)
library(phytools)
library(ggtree)

setwd("/scratch/rx32940/interrogans_genome/pirate_sero/")

sparse.data <- import_fasta_sparse_nt("out/core_alignment.fasta")
sparse.data <- optimise_prior(sparse.data, type = "baps")
baps.hc <- fast_baps(sparse.data)
best.partition <- best_baps_partition(sparse.data, baps.hc)
iqtree <- read.newick( "../iqtree/int_sero_iqtree.newick")
plot.df <- data.frame(id = colnames(sparse.data$snp.matrix), fastbaps = best.partition, 
    stringsAsFactors = FALSE)
gg <- ggtree(iqtree)
f2 <- facet_plot(gg, panel = "fastbaps", data = plot.df, geom = geom_tile, aes(x = fastbaps), 
    color = "blue")
ggsave("core_genome_fastbaps.pdf")

baps_pirate <- data.frame(best.partition) %>% mutate(BioSample.Accession = rownames(.)) %>% rename(pirate_baps = best.partition )
write.csv(baps_pirate, "pirate_baps_for_each_acc.csv")