path <- "/Users/rx32940/Downloads/"
data <- read.table(paste(path, "SAMN_Organism_1209.txt",sep=""), header = FALSE,sep = ",")

head(data)

Organism_names <- data$V2

head(Organism_names)

split_name <- lapply(as.character(Organism_names), function (x) strsplit(x," ")) # return a list

genus <- lapply(split_name, function(x) unlist(x)[1]) # returns all atomic components in the list, take the first component

species <- lapply(split_name, function(x) unlist(x)[2])

full_names <- paste(genus,species)

data$V3 <- full_names

write.csv(data ,paste(path,"Organism_fullname_1209.txt", sep=""))


