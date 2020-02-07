data <- read.table("/Users/rx32940/Dropbox/5.Rachel-projects/Phylogeography/Organism_fullname_1209.txt",sep=",", header = TRUE)

unique_species_num <- length(unique(data$V3))
unique_species <- unique(data$V3)
freq_species <- summary(data$V3)

for (a_species in unique_species){
  this_species <- as.vector(data[data$V3 %in% c(a_species),])
  write.csv(this_species, paste("/Users/rx32940/Desktop/",a_species,sep=""))
  
}
