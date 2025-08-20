#!/bin/bash -   
#title          :DAS Tool 1.1.5 for genome resolved metagenomics
#description    :For sequence annotation 
#author         :Justus Nweze
#date           :20221102
#version        :
#usage          :
#==============================================================================================

logFile="14_DasTool.log"

# DAS Tool is an automated method that integrates the results of a flexible number of binning algorithms to calculate an optimized, non-redundant set of bins from a single assembly.

#===================================================================================================================

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/7E

mkdir DASTool_Bin

# Preparation of input files
# to convert a set of bins in fasta format to tabular contigs2bin file, which can be used as input

# For concoct
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i Concoct > DASTool_Bin/Concoct_contig2bin.tsv &&

# For metabat2
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i Metabat2 > DASTool_Bin/Metabat2_contig2bin.tsv &&

# For MaxBin
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i MAXBIN > DASTool_Bin/MaxBin_contig2bin.tsv &&



cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/7E

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MAXBIN -c CONTIGS/contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --write_unbinned --threads 10

cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/8E

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MAXBIN -c CONTIGS/contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --write_unbinned --threads 10


cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/9E

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MAXBIN -c CONTIGS/contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --write_unbinned --threads 10


cd ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/10E

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MAXBIN -c CONTIGS/contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --write_unbinned --threads 10




mv ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/7E/DASTool_Bin/_DASTool_bins/7E_*.fa DASTool_All_Bin

mv ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/8E/DASTool_Bin/_DASTool_bins/8E_*.fa DASTool_All_Bin

mv ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/9E/DASTool_Bin/_DASTool_bins/9E_*.fa DASTool_All_Bin

mv ~/proj/Peat_soil/Peat_metagenome2022/Data/Single_assmbly/10E/DASTool_Bin/_DASTool_bins/10E_*.fa DASTool_All_Bin













/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv -l Concoct -c ASSEMBLY/final.contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --threads 60

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Metabat2_contig2bin.tsv -l Metabat2 -c ASSEMBLY/final.contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --threads 60

/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/MaxBin_contig2bin.tsv -l MAXBIN -c ASSEMBLY/final.contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --threads 60


#/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MaxBin -c CONTIGS/contigs.fa -o DASTool_Bin/ --write_bins --write_unbinned --threads 5



# https://maveric-informatics.readthedocs.io/en/latest/Processing-a-Microbial-Metagenome.html



chmod +x ./home/nwezejus/Peat_metagenome2022/Analysis/Rename/Rename_Maxbin.sh


#Some binning tools (such as CONCOCT) provide a comma separated tabular output. 
# To convert a comma separated file into a tab separated file a one liner can be used

#   perl -pe "s/,/\t/g;" contigs2bin.csv > contigs2bin.tsv

#Converting CONCOCT csv output into tab separated contigs2bin file
# perl -pe "s/,/\tconcoct./g;" concoct_clustering_gt1000.csv > concoct.contigs2bin.tsv














mkdir DASTool_Bin

# Preparation of input files
# to convert a set of bins in fasta format to tabular contigs2bin file, which can be used as input

# For concoct
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i Concoct > DASTool_Bin/Concoct_contig2bin.tsv &&

# For metabat2
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i Metabat2 > DASTool_Bin/Metabat2_contig2bin.tsv &&

# For MaxBin
/home/nwezejus/DAS_Tool_master/src/Fasta_to_Contig2Bin.sh -e fa -i MAXBIN > DASTool_Bin/MaxBin_contig2bin.tsv &&



# Contatinate all contigs.fa
find . -maxdepth 1 -name \*.fa | xargs cat > New/output.fa


/home/nwezejus/DAS_Tool_master/DAS_Tool -i DASTool_Bin/Concoct_contig2bin.tsv,DASTool_Bin/Metabat2_contig2bin.tsv,DASTool_Bin/MaxBin_contig2bin.tsv -l Concoct,Metabat2,MAXBIN -c CONTIGS/Contigs.fa -o DASTool_Bin/ --search_engine diamond --write_bins --write_unbinned --threads 10






















