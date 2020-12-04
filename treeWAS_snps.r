library(tidyverse)
library(dplyr)

file_path <- "/scratch/rx32940/interrogans_genome/pirate_sero/"

# VCF file wrangling 
vcf <- read.csv(paste0(file_path, "gubbins/interrogans_sero.summary_of_snp_distribution.vcf"), sep="\t", header = FALSE)[-c(1:3),c(1:307)] # take out vcf file header
rownames(vcf) <- NULL
colnames(vcf) <- as.character(unlist(vcf[1,])) # set headers
vcf <- vcf[-1,] 

# To binary
BioAccession <- colnames(vcf)[-c(1:9)]
temp <- data.frame(BioAccession=BioAccession)
rownames(temp) <- BioAccession
for (row in 1:length(vcf[,1])){
  current <- as.data.frame(vcf[row,])
  current_postion <- current$POS
  current_ref <- current$REF
  
  current_column <- as.data.frame(t(as.data.frame(lapply(current[,-c(1:9)],function(x){
    if(x == current_ref){
      return(1)
    }else{
      return(0)
    }
  }))))
colnames(current_column) <- paste0(current_postion, ".",current_ref)
temp <- cbind(temp,current_column)
current_alt <- unlist(strsplit(as.character(current$ALT),','))
for (alt in 1:length(current_alt)){

current_column <-t(as.data.frame(lapply(current[,-c(1:9)],function(x){
if(x == current_alt[alt]){
    return(1)
}else{
    return(0)
}
})))
colnames(current_column) <- paste0(current_postion, ".", current_alt[alt])
temp <- cbind(temp, current_column)
}

}

temp <- temp %>% select(-c("BioAccession"))
write.csv(temp,paste0(file_path, "treeWAS/snps_binary_sero.csv",row.names = FALSE))


