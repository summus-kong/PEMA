#!/usr/bin/Rscript
# Calculate mean expression of metabolism-asscoiate genes from Ribo-seq data
# Get weighted value and finally reaction scores

args <- commandArgs(trailingOnly = TRUE)
# 1: pre tmp matrix
# 2: Riboseq data matrix
# 3: species
# 4: out dir


library(tidyr)
library(readr)
library(dplyr)
library(stringr)
library(stringi)

# define function
get_reaction_consistencies <- function(reaction_penalties,
                                       min_range = 1e-3){
  # Converts the raw penalties outputs of compass into scores per reactions
  # where higher numbers indicate more activity
  df <- -log(reaction_penalties + 1)
  # compare with threshold
  keep_rows <- apply(df, 1, function(row) {
    diff <- max(row) - min(row)
    diff > min_range
  })
  # keep rows
  df <- df[keep_rows, ]
  df <- df - min(df)
  df$reaction_no_direction <- stri_reverse(str_split_fixed(stri_reverse(rownames(df)), '_', 2)[, 2])
  df$states <- stri_reverse(str_split_fixed(stri_reverse(rownames(df)), '_', 2)[, 1])
  return(df)
}

# load data
reaction_meta <- read_csv('./data/reaction_metadata.csv')
metabo <- read_delim(args[1]) %>% as.data.frame() # 1
rownames(metabo) <- metabo[, 1]
transl_act <- read_csv(args[2]) # 2
colnames(transl_act) <- c('gene', colnames(transl_act)[-1])

# get metabolism-associated genes
# homo_sapiens mus_musculus 3
if(args[3] == 'homo_sapiens'){
  rea_meta_longer <- separate_longer_delim(reaction_meta, associated_genes, '; ')
} else if(args[3] == 'mus_musculus'){
  rea_meta_longer <- separate_longer_delim(reaction_meta, associated_genes, '; ') %>%
    mutate(associated_genes = str_to_title(associated_genes))
}

# Calculate weighted values per reaction
cols <- c('reaction_no_direction', colnames(transl_act)[-1])
trans_react <- left_join(rea_meta_longer, transl_act, by = c('associated_genes' = 'gene'))
trans_react_coef <- trans_react[, cols] %>%
  group_by(reaction_no_direction) %>%
  summarise_if(is.numeric, ~mean(., na.rm = T)) %>% as.data.frame()
trans_react_coef[is.na(trans_react_coef)] <- 1
trans_react_coef[, 2:ncol(trans_react_coef)] <- t(scale(t(trans_react_coef[, 2:ncol(trans_react_coef)]), center = F))
rownames(trans_react_coef) <- trans_react_coef$reaction_no_direction
trans_react_coef <- subset(trans_react_coef, select = -c(reaction_no_direction))

# reaction scores
reaction_consistencies <- get_reaction_consistencies(metabo[, 2:ncol(metabo)])
rs <- reaction_consistencies
rs[, colnames(transl_act)[-1]] <- rs[, colnames(transl_act)[-1]] * trans_react_coef[reaction_consistencies$reaction_no_direction, ]
rownames(rs) <- paste(rs$reaction_no_direction, rs$states, '_')
rs <- subset(rs, select = -c(reaction_no_direction, states))

# out
out <- paste(args[4], 'weighted_reactions.txt', sep = '/')
write.table(rs, out, row.names = T)