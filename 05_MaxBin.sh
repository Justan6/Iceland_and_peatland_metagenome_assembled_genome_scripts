#!/bin/bash -   
#title          :Importing outside concoct bin into anvio and profiling.sh
#description    :For sequence annotation 
#author         :Justus Nweze
#date           :20221102
#version        :
#usage          :Activate anvio-7 before running this script

# Activate the test-env conda environment
conda activate test-env

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/7E &&

mkdir -p MAXBIN
run_MaxBin.pl -thread 8 -contig CONTIGS/contigs.fa -reads ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0007E_R1.trim.fastq -reads2 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0007E_R2.trim.fastq -out MAXBIN/7E_MAXBIN -min_contig_length 1000

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/8E &&

mkdir -p MAXBIN
run_MaxBin.pl -thread 8 -contig CONTIGS/contigs.fa -reads ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R1.trim.fastq -reads2 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R2.trim.fastq -out MAXBIN/8E_MAXBIN -min_contig_length 1000




cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/9E &&

mkdir -p MAXBIN
run_MaxBin.pl -thread 8 -contig CONTIGS/contigs.fa -reads ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0009E_R1.trim.fastq -reads2 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0009E_R2.trim.fastq -out MAXBIN/9E_MAXBIN -min_contig_length 1000

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/10E &&

mkdir -p MAXBIN
run_MaxBin.pl -thread 8 -contig CONTIGS/contigs.fa -reads ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R1.trim.fastq -reads2 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R2.trim.fastq -out MAXBIN/10E_MAXBIN -min_contig_length 1000




