# load annotations
diamond_annotations <- read_excel("diamond_target_annotations.xlsx") %>% 
  glimpse

# append annotations
table_annotated <- separate(a1_table, sseqid, sep = '-', into = c("gene", "accession"), remove = F) %>% 
  inner_join(diamond_annotations, "gene") %>% 
  glimpse

# filter target genes
coxl <- filter(table_annotated, function_diamond == "Carbon monoxide oxidation")
methane <- filter(table_annotated, function_diamond == "Methane oxidation")
hydrogenase <- filter(table_annotated, function_diamond == "hydrogenase")