#!/bin/bash
# Title       : Mapping.sh
# Description : A script to map reads in different folders.
# Author      : Justus Nweze
# Date        : 20210429
# Version     : Referenced from within https://merenlab.org/tutorials/assembly-based-metagenomics/
# Usage       : Run the command chmod +x ./Mapping.sh and then ./Mapping.sh

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly2/7E

mkdir CONTIGS                                                                                                                                                                                                     
        anvi-script-reformat-fasta ASSEMBLY/final.contigs.fa -o CONTIGS/contigs.fa -l 1000 --simplify-names --report CONTIGS/name_conversions.txt

# Create a directory for mapping                
mkdir -p MAPPING

# Build Bowtie2 index files from the reference sequence information saved in the FASTA files                  
bowtie2-build CONTIGS/contigs.fa MAPPING/contigs                                                              

# You need to make sure "ls trimmed_fastq/*_R1.trim.fastq" returns R1 files for all your samples in samples.txt
R1s=$(ls ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R1.trim.fastq | tr '\n' ',' | sed 's/,$//')
R2s=$(ls ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R2.trim.fastq | tr '\n' ',' | sed 's/,$//')

# Map reads using Bowtie2                                                               
bowtie2 -x MAPPING/contigs -1 $R1s -2 $R2s --no-unal -p 4 -S MAPPING/JMF-2110-11-0010E.sam

# Convert SAM to BAM and initialize BAM file      
samtools view -F 4 -bS MAPPING/JMF-2110-11-0010E.sam > MAPPING/JMF-2110-11-0010E-RAW.bam                                                                                                                                                

anvi-init-bam MAPPING/JMF-2110-11-0010E-RAW.bam -o MAPPING/JMF-2110-11-0010E.bam          


rm MAPPING/*.sam MAPPING/*-RAW.bam 
# Remove bowtie2-build files (if no longer needed)
rm -f MAPPING/*.bt2

