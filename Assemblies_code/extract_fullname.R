# extract full name from list of biosamples - strain names with python script species_SAMN.py
path = "/Users/rx32940/Dropbox/5.Rachel-projects/Phylogeography/Lepto_assemblies_V2/ncbi_assemblies/"
data <- read.table(paste(path, "ncbi_assemblies_species.txt",sep=''), header = FALSE,sep = ",")

head(data)

Organism_names <- data$V2

head(Organism_names)

split_name <- lapply(as.character(Organism_names), function (x) strsplit(x," ")) # return a list

genus <- lapply(split_name, function(x) unlist(x)[1]) # returns all atomic components in the list, take the first component

species <- lapply(split_name, function(x) unlist(x)[2])

full_names <- paste(genus,species)

data$V3 <- full_names

write.csv(data ,paste(path,"fullname_651.txt", sep=""))


