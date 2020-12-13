library(ggplot2)

cattle <- 99
pigs <- 106
sheep <- 106
goats <-  105

cattle_pos <- 79
pig_pos <- 68
sheep_pos <- 38
goats_pos <- 26

serop <- data.frame(livestock = c("cattle", "pigs", "sheep", "goats"), 
           Total_samples = c(cattle, pigs, sheep, goats),
           postive=c(cattle_pos, pig_pos, sheep_pos, goats_pos))

ggplot(serop, aes(x=livestock, y=(positive/Total_samples)*100))+
         geom_col()+
  labs(y="Seroprevalence", x="Livestock Hosts")+
  geom_text(aes(label=paste0(floor((positive/Total_samples)*100), "%")), vjust=-0.5)+
  theme_bw()+
  theme(axis.title = element_text(size=14), axis.text=element_text(size=14))


  