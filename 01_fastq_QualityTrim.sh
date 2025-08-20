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
  

##========= Raw data processing

#=================================================================================================================
# Quality check is the first step, where the metagenomes summary statistics including the number of read sequences, minimum length, maximum length, quality scores for fastq sequences, number of sequence duplicates, ambiguous bases (N’s), etc. are calculated.It is done check if universal adapters are present.
#=================================================================================================================

#1. Quality filtering
        mkdir Single_fastq/fastqc &&  #--make directory
        mkdir Single_fastq/ForRev &&  #--make directory

# Use this on ForRev file (F & R) or on sible files

fastqc -f fastq Single_fastq/*_R*.fastq -o Single_fastq/fastqc


# ========================================================================================================

#!/bin/bash


conda activate fastp-env

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





