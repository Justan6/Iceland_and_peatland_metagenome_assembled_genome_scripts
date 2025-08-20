#!/bin/bash -   
#title          :Assembly.sh
#description    :A simple loop to serially map all samples
#author         :Justus Nweze
#date           :20210429
#version        :Referenced from within http://merenlab.org/tutorials/assembly_and_mapping
#usage          :Run the command
#===========================================================================================================



logFile="02_Assembly.log"

# Change directory to data folder
	cd ~/Peat_metagenome2022/Data &&

#=================================================================================================================
#1 Activate conda in the terminal with: source activate   
#2. Use conda to activate anvio: conda activate anvio-7.1

# Follow the next step if it doesn't work in zsh
	
# Use the following to activate anvio-7.1 before running in zsh or run it bash by typing bash in the command line 

#	zsh
#	conda activate base
#	conda activate anvio-7.1
# OR
#	bash
#=================================================================================================================
#   7E

# Single-assemble to produce a single contigs.fa

#	megahit -1 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0007E_R1.trim.fastq,../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R1.trim.fastq -2 ../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0007E_R2.trim.fastq,../../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R2.trim.fastq -o ASSEMBLY -t 10 

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly2/7E &&

megahit -r ../../Single_fastq/JMF-2110-11-0007E.fastq -o ASSEMBLY -t 8  --presets meta-large &&


cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly2/8E &&

megahit -r ../../Single_fastq/JMF-2110-11-0008E.fastq -o ASSEMBLY -t 8  --presets meta-large



cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly2/9E &&

megahit -r ../../Single_fastq/JMF-2110-11-0009E.fastq -o ASSEMBLY -t 8  --presets meta-large &&


cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly2/10E &&

megahit -r ../../Single_fastq/JMF-2110-11-0010E.fastq -o ASSEMBLY -t 8  --presets meta-large

#=================================================================================================================
#   8E

# Single-assemble to produce a single contigs.fa

#	megahit -1 ../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R1.trim.fastq -2 ../Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0008E_R2.trim.fastq -o ASSEMBLY_8E -t 50 
#=================================================================================================================
#   9E

# Single-assemble to produce a single contigs.fa

#	megahit -1 Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0009E_R1.trim.fastq -2 Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0009E_R2.trim.fastq -o ASSEMBLY_9E -t 50  
#=================================================================================================================
#   10E

# Single-assemble to produce a single contigs.fa

#	megahit -1 Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R1.trim.fastq -2 Single_fastq/ForRev/trimmed_fastq/JMF-2110-11-0010E_R2.trim.fastq -o ASSEMBLY_10E -t 50 

#=================================================================================================================

#   megahit   is the command, it is specifying the program we are using
#   -1        is for specifying the forward reads. Since we are doing a co-assembly of multiple samples, we could   have stuck them altogether first into one file, but megahit allows multiple samples to be added at once. Notice here we are specifying all the forward reads in a list, each separated by a comma, with no spaces. This is because spaces are important to the command-line’s interpretation, whereas commas don’t interfere with how it is interpreting the command and the information gets to megahit successfully.
#   -2         contains all the reverse read files, separated by commas, in the same order.
#   -o         specifies the output directory (the program will produce information in addition to the final output assembly)
#   -t         specifies that we want to use 50 cpus (some programs can be run in parallel, which means splitting the work up and running portions of it simultaneously. Some can use 4 cpus but it will take time)
        	


#=================================================================================================================
# “Co-assembly” refers to performing an assembly where the input files would be reads from multiple samples.
# Examples of genome assemblers are: SPAdes, Megahit, idba-ud, Minia, QUAST (for individual genome assembly) or MetaQUAST (for metagenome assemblies)
# These assemblers are compared here: https://astrobiomike.github.io/genomics/de_novo_assembly#comparing-assemblies
