#!/bin/bash -   
#title          :Diamond_blastp.sh
#description    :DIAMOND is a sequence aligner for protein and translated DNA searches, designed for high performance analysis of big sequence data. 
#author         :Justus Nweze
#date           :20210429
#version        :v1
#usage          :Run the command
#===========================================================================================================

# Step 1: Gene prediction using Prodigal
# Prodigal is a fast and reliable tool for protein-coding gene prediction in prokaryotic genomes.

# Change directory to the data folder containing the assembled sequences
cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly &&

# Create a directory to store Prodigal output
mkdir All_Iceland_proteins &&

# Define an array of sample names
samples=("A1" "A2" "A4" "A5" "W1" "W2" "W4" "W5")

# Loop through each sample and run Prodigal
for sample in "${samples[@]}"
do
    # Set input file path and output directory
    input_file="${sample}/ASSEMBLY/final.contigs.fa"
    output_dir="All_Iceland_proteins"
    output_file="${sample}.proteins.faa"

    # Run Prodigal for gene prediction
    prodigal -i "${input_file}" -o "${output_dir}/${sample}" -a "${output_dir}/${output_file}" -p meta
done

#==================================================================================================================
# Step 2: Gene prediction using geneRFinder
# geneRFinder is another tool for prokaryotic gene prediction.
# NOTE: It did not finish running before the server was killed.

# Activate geneRFinder environment
conda activate geneRFinder

# Change directory to the data folder
cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly &&

# Create a directory for geneRFinder output
mkdir All_Iceland_proteins_GeneRFinder &&

# Loop through each sample and run geneRFinder
for sample in "${samples[@]}"
do
    # Set input file path and output directory
    input_file="${sample}/ASSEMBLY/final.contigs.fa"
    output_dir="All_Iceland_proteins"

    # Run geneRFinder using an R script
    Rscript ./geneRFinder.R -i "${input_file}" -o "${output_dir}/${sample}" -t 8 -s 1 -n 1
done

#================================================================================================================
# Step 3: Build a DIAMOND nr database
# DIAMOND supports creating a custom database for protein alignment.

# Download necessary files for taxonomic mapping
# --taxonmap: File for mapping accession numbers to taxids
# --taxonnodes, --taxonnames: Taxonomic nodes and names
# Funcgenes_51_Sep2023 from Greening lab metabolic marker gene databases via https://bridges.monash.edu/collections/Greening_lab_metabolic_marker_gene_databases/5230745

# Process all downloaded gzipped files to create DIAMOND database
for file in *.gz; do
    diamond makedb --in $file --db ../Diamond_database/Funcgenes_51_Sep2023 \
    --taxonmap ../prot.accession2taxid.FULL.gz \
    --taxonnodes ../taxdmp/nodes.dmp \
    --taxonnames ../taxdmp/names.dmp \
    --threads 5
done

#================================================================================================================
# Step 4: Perform a DIAMOND blastp search to test the database
# Compare translated protein-assembled reads against a curated database.

# Activate DIAMOND environment
# conda activate Diamond

# Run DIAMOND blastp for a single sample
diamond blastp -p 10 -d ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Database/Funcgenes_51_Dec2021.dmnd \
-q A1.proteins.faa -o ../Assembled_read_Annotation_file.txt \
-p 5 -k 1 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend \
sstart send evalue bitscore qcovhsp salltitles

# Notes on key output fields:
# - evalue: Statistical measure of alignment significance (lower values are better)
# - bitscore: Measure of alignment significance (higher values are better)

#================================================================================================================
# Step 5: DIAMOND blastp for multiple files
# Annotate all .faa files in the current directory

# Create output directory for annotations
mkdir MAG_Contig_Annotation
cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly/All_Iceland_proteins

# Set DIAMOND database path
database_path="/home/nwezejus/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Database/Diamond_database/Funcgenes_51_Sep2023.dmnd"

# Loop through all .faa files and run DIAMOND blastp
for input_file in *.faa; do
    # Define output file path
    output_file="../MAG_Contig_Annotation/${input_file%.faa}_Annotation_file.txt"
    
    # Run DIAMOND blastp
    diamond blastp -p 10 -d "$database_path" -q "$input_file" -o "$output_file" \
    -k 1 --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend \
    sstart send evalue bitscore qcovhsp salltitles staxids
done

#================================================================================================================
# Step 6: Extract taxonomy from protein accessions
# Use EDirect to access taxonomy info from protein accessions.

# Activate EDirect environment
conda activate edirect

# Fetch taxonomy information for a single protein accession
efetch -db protein -id PYO31547.1 -format xml | xtract -pattern Seq-entry \
       -def "NA" -element Textseq-id_accession,Textseq-id_version \
       -block BioSource_org -def "NA" -element Object-id_id,OrgName_lineage

# Process multiple protein accessions from a file
epost -input accessions.txt -db protein | efetch -format xml | xtract -pattern Seq-entry \
      -def "NA" -element Textseq-id_accession,Textseq-id_version \
      -block BioSource_org -def "NA" -element Object-id_id,OrgName_lineage > Accs_Output.txt

