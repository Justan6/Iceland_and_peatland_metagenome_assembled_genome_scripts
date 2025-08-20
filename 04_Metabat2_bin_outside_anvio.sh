#!/bin/bash  
#title          :Importing outside concoct bin into anvio and profiling.sh
#description    :For sequence annotation 
#author         :Justus Nweze
#date           :2023.10.5
#version        :V1
#usage          :Activate test-env before running this script
#==============================================================================================
# Activate test-env before running this script
#   chmod +x ./proj/Peat_soil/Peat_metagenome2022/Analysis/Single_assembly/04_Metabat2_bin_outside_anvio.sh

# Activate the test-env conda environment
conda activate test-env

# List of folders
folders=("7E" "8E" "9E" "10E")

# Loop through folders
for folder in "${folders[@]}"; do
    # Change directory to the data folder
    cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/"$folder"

    # Create a directory to store MetaBAT2 results within the current folder
    mkdir -p metabat2

    # Generate a depth file from BAM files
    jgi_summarize_bam_contig_depths --outputDepth depth.txt MAPPING/*E.bam

    # Run MetaBAT2
    metabat2 -i CONTIGS/contigs.fa -a depth.txt -o metabat2/"$folder"_metabat2

    # Change back to the parent directory
    cd ..
done





