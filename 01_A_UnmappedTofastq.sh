#!/bin/bash -   
#title          :UnmappedTofastq.sh
#description    :Metagenomic analysis with anvio-7
#author         :Julius Nweze
#date           :20210429
#version        :1.0   
#usage          :Run the command in the Analysis folder
#============================================================================


#       This is the FIRST thing to do when you receive your metagenome data from the sequencing company
#            #Workflow to reconstruct metagenome-assembled genomes (MAGs) from microbiomes 
#=================================================================================================================
##========= Description

# Pipeline to reconstruct population genomes from microbiomes, including quality check, assembly, and binning.

#1. login with ssh -L 8080:localhost:8080 nwezejus@172.24.2.11
#2. Create two folders with names: Analysis and Data
#3. You can use scp or cp command to transfer your bam files to "Data" folder
        

#=================================================================================================================
#                   Check if the bam files you received have been mapped or not
#                   Using samtools flagstat input.bam 
#	                samtools flagstat *.bam 
#=================================================================================================================

logFile="01_UnmappedTofastq.log" #If you want to follow the pregress

# =============== Extracting paired FASTQ read data from a BAM mapping file =====================

# Change directory to the folder containing your data (unmapped bam files)
	cd ~/Metagenomics_tutoral/Data/ &&
    mkdir Single_fastq
	for Sample in *.bam
	do
	samtools bam2fq $Sample > Single_fastq/"${Sample/.bam/.fastq}"  # Using bam2fq to convert bam to a single fastq file
	done &&

	
    mkdir Single_fastq/ForRev
	for Sample in Single_fastq/*.fastq
	do
	cat $Sample | grep '^@.*/1$' -A 3 --no-group-separator > ${Sample/.fastq/}_R1.fastq # To split a single .fastq file into two separated files
	cat $Sample | grep '^@.*/2$' -A 3 --no-group-separator > ${Sample/.fastq/}_R2.fastq 
	done &&
    mv Single_fastq/*_R1.fastq Single_fastq/*_R2.fastq Single_fastq/ForRev && # move all *_R1.fastq and *_R2.fastq to ForRev

    mkdir raw_data 
    mv *.bam raw_data # make directory "raw_data" and move all .bam file into it.



