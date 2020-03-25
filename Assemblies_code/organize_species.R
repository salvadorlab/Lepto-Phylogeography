# use full name file extracted by R script extract_fullname.R
path = "/Users/rx32940/Dropbox/5.Rachel-projects/Phylogeography/Lepto_assemblies_V2/ncbi_assemblies/"
data <- read.table(paste(path,"fullname_651.txt",sep=''),sep=",", header = TRUE)

head(data)

unique_species_num <- length(unique(data$V3))
unique_species <- unique(data$V3)
freq_species <- summary(data$V3)

for (a_species in unique_species){
  this_species <- as.vector(data[data$V3 %in% c(a_species),])
  write.csv(this_species, paste(path,"species_list/",a_species,sep=""))
  
}
