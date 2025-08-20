#!/bin/bash -   
#title          :Importing outside concoct bin into anvio and profiling.sh
#description    :For sequence annotation 
#author         :Justus Nweze
#date           :20221102
#version        :
#usage          :Activate anvio-7 before running this script
#==============================================================================================

logFile="10_Concoct_bin_outside_anvio.log"

#Activate test-env (anvio-7.1) before running this script
# conda activate test-env

# Change directory to data folder
	cd ~/nwezejus/Peat_metagenome2022/Data/SpAde_assmbly
conda activate test-env

# Cut contigs into smaller parts. For spade assembly use contigs.fasta
    cut_up_fasta.py CONTIGS/contigs.fa -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa && 


#Generate table with coverage depth information per sample and subcontig. This step assumes the directory 'mapping' contains sorted and indexed bam files where each sample has been mapped against the original contigs.

     concoct_coverage_table.py contigs_10K.bed MAPPING/JMF-2110-11-00*E.bam > coverage_table.tsv && 

#Run concoct

    concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output/ -t 10 && 

#Merge subcontig clustering into original contig clustering

    merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv && 

#Extract bins as individual FASTA

mkdir concoct_output/fasta_bins && 
extract_fasta_bins.py CONTIGS/contigs.fa concoct_output/clustering_merged.csv --output_path concoct_output/ && 

#  Use CheckM to investigate the bins contamination and completeness 
    
    checkm lineage_wf -x fa concoct_output/fasta_bins CheckMOut_concoct -t 5








cd ~/Iceland_metagenome/Single_assembly/A1 &&
mkdir concoct_output &&

cut_up_fasta.py ASSEMBLY/final.contigs.fa -c 10000 -o 0 --merge_last -b contigs_10K.bed > contigs_10K.fa &&

concoct_coverage_table.py contigs_10K.bed MAPPING/*.sorted.bam > coverage_table.tsv &&

concoct --composition_file contigs_10K.fa --coverage_file coverage_table.tsv -b concoct_output/ -t 40 &&

merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv &&

mkdir concoct_output/fasta_bins &&
extract_fasta_bins.py ASSEMBLY/final.contigs.fa concoct_output/clustering_merged.csv --output_path concoct_output/



