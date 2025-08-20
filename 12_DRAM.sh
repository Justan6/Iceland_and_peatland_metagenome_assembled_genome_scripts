#!/bin/bash -   
#title          :DRAM (Distilled and Refined Annotation of Metabolism)
#Current Version: 
#description    :a tool for annotating metagenomic assembled genomes and VirSorter identified viral contigs. DRAM annotates MAGs and viral contigs using KEGG (if provided by the user), UniRef90, PFAM, dbCAN, RefSeq viral, VOGDB and the MEROPS peptidase database as well as custom user databases.
#author         :Justus Nweze
#date           :20221208
#usage          : before running this script

#==================================================================================================================
    logFile="30_DRAM.log"
#==================================================================================================================
#    wget https://raw.githubusercontent.com/shafferm/DRAM/master/environment.yaml
#    conda env create -f environment.yaml -n myDRAM
#==================================================================================================================
#           Running the program
#==================================================================================================================
# Change to your working directory
    cd Peat_metagenome2022/Data/Single_assmbly2/Metabolic_Bins &&

# Activate metabolic working environment    
#    conda activate myDRAM
#    pip install DRAM-bio
#    DRAM-setup.py prepare_databases --output_dir DRAM_data
#To test that your set up worked use the command
#    DRAM-setup.py print_config
#E.g.   DRAM.py annotate -i Bin/GCF_000005845.2.fasta -o test-DRAM-output
#==================================================================================================================

    conda activate myDRAM   
# Bins MUST have file extension of fasta or fna    
    DRAM.py annotate -i 'Bins/*.fasta' -o DRAM_anno --threads 20
    DRAM.py annotate -i 'MAGs/*.fasta' -o annotation --min_contig_size 1000 --gtdb_taxonomy gtdbtk.bac120.summary.tsv --checkm_quality checkm_results

#summarize the annotations with 
    DRAM.py distill -i DRAM_anno/annotations.tsv -o DRAM_anno/genome_summaries --trna_path DRAM_anno/trnas.tsv --rrna_path DRAM_anno/rrnas.tsv
#==================================================================================================================




conda activate myDRAM
cd /proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly/Old/Methylomirabilis_Genomes/New_comparism/ANNOTATIONS/DRAM

DRAM.py annotate -i '../Data/*.fasta' -o DRAM_anno --threads 5
   
#summarize the annotations with 
    DRAM.py distill -i DRAM_anno/annotations.tsv -o DRAM_anno/genome_summaries --trna_path DRAM_anno/trnas.tsv --rrna_path DRAM_anno/rrnas.tsv

#==================================================================================================================



#KEGGCharter is a user-friendly implementation of KEGG API and Pathway functionalities. It allows for:

#    Conversion of KEGG IDs, EC numbers and COG IDs to KEGG Orthologs (KO) and of KO to EC numbers
#    Representation of the metabolic potential of the main taxa in KEGG metabolic maps (each distinguished by its own colour)
#    Representation of differential expression between samples in KEGG metabolic maps (the collective sum of each function will be represented)

conda activate My_KEGGCharter

# conda install -c conda-forge -c bioconda keggcharter
# metabolic representations for "Methane Metabolism" (KEGG map00680)

keggcharter -f reCOGnizer_results.xlsx -rd resources_directory -keggc 'KEGG' -ecc 'EC number' -cogc 'COG ID' -iq -it "Methylomirabiales" -mm 00680 -o Methane_metabolism


keggcharter -f UPIMAPI_results.tsv -rd resources_directory -keggc 'KEGG' -koc 'KO' -ecc 'EC number' -cogc 'COG ID' -iq -it "Methylomirabiales" -mm 00680 -o Methane_metabolism










































#==================================================================================================================


