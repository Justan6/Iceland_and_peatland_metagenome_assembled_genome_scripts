#!/bin/bash -   
#title          :QualityTrim.sh
#description    :Metagenomic analysis with anvio-7
#author         :Justus Nweze
#date           :23022022
#version        :1.0   
#usage          :Run the command in the Analysis folder
#============================================================================


#            Workflow to reconstruct metagenome-assembled genomes (MAGs) from microbiomes with Anvi'o
#=================================================================================================================
##========= Description

# Pipeline to reconstruct population genomes from microbiomes, including quality check, assembly, and binning.

#1. login with ssh -L 8080:localhost:8080 nwezejus@172.24.2.11
#2. Change to your work directory to Data: 
     cd ~/Metagenomics_tutoral/Data && 
#=================================================================================================================
  # Check sequencing depth
# ~/proj/Peat_soil/Peat_metagenome2022/Analysis/fastqinfo-2.0.sh -r INSERT_SIZE R1.fastq R2.fastq ASSEMBLY.fasta 

##========= Raw data processing

#=================================================================================================================
# Quality check is the first step, where the metagenomes summary statistics including the number of read sequences, minimum length, maximum length, quality scores for fastq sequences, number of sequence duplicates, ambiguous bases (N’s), etc. are calculated.It is done check if universal adapters are present.
#=================================================================================================================

#1. Quality filtering
        mkdir Single_fastq/fastqc &&  #--make directory
        mkdir Single_fastq/ForRev &&  #--make directory

# Use this on ForRev file (F & R) or on sible files

fastqc -f fastq Single_fastq/*_R*.fastq -o Single_fastq/fastqc

# fastqc ForRev*.fastq -o fastqc &&
#=================================================================================================================
# Trimming with trimmpmatic https://carpentries-incubator.github.io/metagenomics/03-trimming-filtering/index.html
# We are going to run Trimmomatic on one of our paired-end samples. While using FastQC, we saw that Universal adapters were present in our samples. The adapter sequences came with the installation of Trimmomatic, so we will first copy these sequences into our current directory.
#=================================================================================================================

# Copy the adapters file TruSeq3-PE.fa in trimmomatic-0.39-2
    cp ~/miniconda3/pkgs/trimmomatic-0.39-hdfd78af_2/share/trimmomatic-0.39-2/adapters/TruSeq3-PE.fa ./Single_fastq/ForRev &&

# Let’s compress the file 
    cd Single_fastq/ForRev &&

#   for reference only (less sensitive for adapters)

#    for Sample in *_R1.fastq
#	do
#    base=$(basename ${Sample} _R1.fastq)
#    trimmomatic PE -threads 50 ${Sample} ${base}_R2.fastq \
#    ${base}_R1.trim.fastq ${base}_R1un.trim.fastq \
#    ${base}_R2.trim.fastq ${base}_R2un.trim.fastq \
#    SLIDINGWINDOW:4:20 MINLEN:35 ILLUMINACLIP:TruSeq3-PE.fa:2:40:15
#    done &&


    for Sample in *_R1.fastq
	do
    base=$(basename ${Sample} _R1.fastq)
    trimmomatic PE -threads 20 -trimlog trimLogFile -summary statsSummaryFile
    ${Sample} ${base}_R2.fastq \
    ${base}_R1.trim.fastq ${base}_R1un.trim.fastq \
    ${base}_R2.trim.fastq ${base}_R2un.trim.fastq \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36
    done &&
#        ILLUMINACLIP:TruSeq3-PE-2.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:15 MINLEN:30

    mkdir untrimmed_fastq
    mv *_R1un.trim.fastq *_R2un.trim.fastq -t untrimmed_fastq

    mkdir trimmed_fastq
    mv *_R1.trim.fastq *_R2.trim.fastq -t trimmed_fastq
    
    mkdir raw_fastq 
    mv *_R1.fastq *_R2.fastq -t raw_fastq 
 
    mkdir fastqc &&  
    fastqc trimmed_fastq/*_R*.trim.fastq -o fastqc

# ==============================================================================================================




cd ~/Iceland_metagenome/Single_fastq/ForRev 

1ForRev

for Sample in *_R1.fastq
do
    base=$(basename ${Sample} _R1.fastq)
    trimmomatic PE -threads 20 -trimlog trimLogFile -summary statsSummaryFile \
    ${Sample} ${base}_R2.fastq \
    ${base}_R1.trim.fastq ${base}_R1un.trim.fastq \
    ${base}_R2.trim.fastq ${base}_R2un.trim.fastq \
    ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36
done &&

mkdir untrimmed_fastq
mv *_R1un.trim.fastq *_R2un.trim.fastq -t untrimmed_fastq

mkdir trimmed_fastq
mv *_R1.trim.fastq *_R2.trim.fastq -t trimmed_fastq

mkdir raw_fastq
mv *_R1.fastq *_R2.fastq -t raw_fastq

mkdir fastqc &&
fastqc trimmed_fastq/*_R*.trim.fastq -o fastqc



ForRev


for Sample in *_R1.fastq
	do
    base=$(basename ${Sample} _R1.fastq)
    trimmomatic PE -threads 20 -trimlog trimLogFile -summary statsSummaryFile>
    ${Sample} ${base}_R2.fastq \
    ${base}_R1.trim.fastq ${base}_R1un.trim.fastq \
    ${base}_R2.trim.fastq ${base}_R2un.trim.fastq \
    ILLUMINACLIP:TruSeq3-PE-2.fa:2:40:15 LEADING:2 TRAILING:2 SLIDINGWINDOW:4:15 MINLEN:30
    done &&

    mkdir untrimmed_fastq
    mv *_R1un.trim.fastq *_R2un.trim.fastq -t untrimmed_fastq

    mkdir trimmed_fastq
    mv *_R1.trim.fastq *_R2.trim.fastq -t trimmed_fastq
    
    mkdir raw_fastq 
    mv *_R1.fastq *_R2.fastq -t raw_fastq 
 
    mkdir fastqc &&  
    fastqc trimmed_fastq/*_R*.trim.fastq -o fastqc



# ========================================================================================================

#!/bin/bash

# Quality trim with fastq

# Set the directory containing the input fastq files
fastq_dir=~/Iceland_metagenome/Single_fastq/ForRev/raw_fastq

# Set the directory to store the trimmed output files
output_dir=~/Iceland_metagenome/Single_fastq/ForRev/raw_fastq/trim

# Loop over all pairs of input fastq files in the directory
for R1_file in ${fastq_dir}/*_R1.fastq
do
    R2_file=${R1_file%_R1.fastq}_R2.fastq
    base=$(basename ${R1_file} _R1.fastq)

    # Run fastp on the pair of files
    fastp --in1 ${R1_file} \
          --in2 ${R2_file} \
          --out1 ${output_dir}/${base}.trim_R1.fastq \
          --out2 ${output_dir}/${base}.trim_R2.fastq \
          --qualified_quality_phred 4 \
          --length_required 31 \
          --correction \
          --json ${output_dir}/${base}.trim.json \
          --html ${output_dir}/${base}.trim.html
done





