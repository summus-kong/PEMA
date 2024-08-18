library(tidyverse)
aaaaa$lacor <- NA
aaaaa$lacp <- NA
for(i in seq_len(nrow(aaaaa))){
  cortlac = cor.test(as.numeric(aaaaa[i, c(2:5)]), as.numeric(aaaaa[i, c(8:11)]), 
                     method = 'pearson')
  # aaaaa[i, 20] <- cortlac
  aaaaa[i, 20] <- as.numeric(cortlac$estimate)
  aaaaa[i, 21] <- as.numeric(cortlac$p.value)
  # cortldh = cor(as.numeric(aaaaa[i, c(2:7)]), as.numeric(aaaaa[i, 14:19]),
  #               method = 'pearson')
  # aaaaa[i, 21] <- cortldh
}