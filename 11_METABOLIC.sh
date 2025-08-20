#!/bin/bash -   
#title          :METABOLIC
#Current Version: 4.0
#description    :This software enables the prediction of metabolic and biogeochemical functional trait profiles to any given genome datasets. These genome datasets can either be metagenome-assembled genomes (MAGs), single-cell amplified genomes (SAGs) or isolated strain sequenced genomes. METABOLIC has two main implementations, which are METABOLIC-G and METABOLIC-C. METABOLIC-G.pl allows for generation of metabolic profiles and biogeochemical cycling diagrams of input genomes and does not require input of sequencing reads. METABOLIC-C.pl generates the same output as METABOLIC-G.pl, but as it allows for the input of metagenomic read data, it will generate information pertaining to community metabolism. It can also calculate the genome coverage. The information is parsed and diagrams for elemental/biogeochemical cycling pathways (currently Nitrogen, Carbon, Sulfur and "other") are produced.
#author         :Justus Nweze
#date           :20221208
#usage          :conda activate fraggenescan before running this script

#==================================================================================================================
    logFile="29_Fraggenescan.log"
#==================================================================================================================
#Program Name 	        Program Description
#METABOLIC-G.pl 	    Allows for classification of the metabolic capabilities of input genomes.
#METABOLIC-C.pl 	    Allows for classification of the metabolic capabilities of input genomes,
#                       calculation of     genome coverage, creation of biogeochemical cycling diagrams,
#                       and visualization of community metabolic interactions and contribution to biogeochemical 
#                       processes by each microbial group.
# Installation
#1 conda env create -f METABOLIC_v4.0_env.yml
#2 conda activate METABOLIC_v4.0
#3 git clone https://github.com/AnantharamanLab/METABOLIC.git
#4 cd METABOLIC
#4 ./run_to_setup.sh
# Activate metabolic environment        

    conda activate METABOLIC_v4.0
#==================================================================================================================
#           Running the program
#==================================================================================================================
# Change to your working directory
    cd Peat_metagenome2022/Data/Single_assmbly2/All_Bins/All_Good_Bins &&


# Activate metabolic working environment    
    conda activate METABOLIC_v4.0
#   perl /home/nwezejus/METABOLIC/METABOLIC-C.pl -help
#   perl /home/nwezejus/METABOLIC/METABOLIC-G.pl -help
#==================================================================================================================
#run METABOLIC-G

    perl /home/nwezejus/METABOLIC/METABOLIC-G.pl -in-gn DASTool_Bin/_DASTool_bins -o Metab_output -t 10
#==================================================================================================================
conda activate METABOLIC_v4.0

cd /proj/Peat_soil/Peat_metagenome2022/Data/Single_assembly/Old/Methylomirabilis_Genomes/New_comparism/ANNOTATIONS/METABOLIC &&

 perl /home/nwezejus/METABOLIC/METABOLIC-G.pl -in-gn ../Data -o Metab_output -t 5
#==================================================================================================================
perl /home/nwezejus/METABOLIC/METABOLIC-G.pl -in-gn Genome/Used/One -o Metab_output3 -t 10
#==================================================================================================================


