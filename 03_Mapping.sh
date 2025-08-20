#!/bin/bash
# Title       : Mapping.sh
# Description : A script to map reads in different folders.
# Author      : Justus Nweze
# Date        : 20210429
# Version     : Referenced from within https://merenlab.org/tutorials/assembly-based-metagenomics/
# Usage       : Run the command chmod +x ./Mapping.sh and then ./Mapping.sh

# Function to map reads
map_reads() {
    local folder="$1"
    local sample="$2"
    
    cd "$folder" || exit 1
    
    # Create directories if they don't exist
    mkdir -p CONTIGS MAPPING
    
    # Reformat the FASTA file
    anvi-script-reformat-fasta ASSEMBLY/final.contigs.fa -o CONTIGS/contigs.fa -l 1000 --simplify-names --report CONTIGS/name_conversions.txt
    
    # Build Bowtie2 index files
    bowtie2-build CONTIGS/contigs.fa MAPPING/contigs
    
    # Map reads using Bowtie2
    R1s=$(ls ../../Single_fastq/ForRev/trimmed_fastq/"$sample"_R1.trim.fastq | tr '\n' ',' | sed 's/,$//')
    R2s=$(ls ../../Single_fastq/ForRev/trimmed_fastq/"$sample"_R2.trim.fastq | tr '\n' ',' | sed 's/,$//')
    
    bowtie2 -x MAPPING/contigs -1 $R1s -2 $R2s --no-unal -p 4 -S MAPPING/"$sample".sam
    
    # Convert SAM to BAM and initialize BAM file
    samtools view -F 4 -bS MAPPING/"$sample".sam > MAPPING/"$sample"-RAW.bam
    anvi-init-bam MAPPING/"$sample"-RAW.bam -o MAPPING/"$sample".bam
    
    # Remove Bowtie2 index files (if no longer needed)
    rm -f MAPPING/*.bt2
    rm MAPPING/*.sam MAPPING/*-RAW.bam 
    
    cd ..
}

# List of folders and samples
folders=("7E" "8E" "9E" "10E")
samples=("JMF-2110-11-0007E" "JMF-2110-11-0008E" "JMF-2110-11-0009E" "JMF-2110-11-0010E")

# Activate conda environment
conda activate anvio-7.1

# Loop through folders and samples
for ((i = 0; i < ${#folders[@]}; i++)); do
    map_reads "~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/${folders[$i]}" "${samples[$i]}"
done

