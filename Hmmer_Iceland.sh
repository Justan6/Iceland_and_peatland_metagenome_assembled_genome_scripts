#!/bin/bash -   
#title          :Assembly.sh
#description    :A simple loop to serially map all samples
#author         :Justus Nweze
#date           :20210429
#version        :Referenced from within http://merenlab.org/tutorials/assembly_and_mapping
#usage          :Run the command
#===========================================================================================================
# Prodigal - Fast, reliable protein-coding gene prediction for prokaryotic genomes.
# Perform gene call and open reading frame

# Change directory to data folder
	cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly &&
# Make a directory for prodigal output   
    mkdir All_Iceland_proteins &&

# Define an array folders containing the sample names where you assembled reads are
samples=("A1" "A2" "A4" "A5" "W1" "W2" "W4" "W5")

# Loop through each folder and run prodigal for each of them
for sample in "${samples[@]}"
do
    input_file="${sample}/ASSEMBLY/final.contigs.fa"
    output_dir="All_Iceland_proteins"
    output_file="${sample}.proteins.faa"

    prodigal -i "${input_file}" -o "${output_dir}/${sample}" -a "${output_dir}/${output_file}" -p meta
done
#================================================================================================================

# Change directory to data folder
	cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly/All_Iceland_proteins &&
mkdir Proteins_Seq &&
mv *.faa Proteins_Seq &&

mkdir All_Amino_acid_Seqs &&

cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly/All_Iceland_proteins/Proteins_Seq &&
#================================================================================================================
# NOTE: If you do not have fasta file of genes you want to search for eg.Formate-dehydrogenase, you can use hmmbuild fdhF.hmm 1.FDHF-Formate-dehydrogenase-H.fasta - to create the hmmm files.


# Run and search for smmo in the folder containing the assembled read proteins

for file in *.faa
do
assembly_id=${file%%.faa}
hmmsearch --tblout ../All_Amino_acid_Seqs/smmo.$assembly_id.txt -A ../All_Amino_acid_Seqs/smmo.$assembly_id.sto --cpu 1 -E 1e-10 ../smmo.hmm ./$file
done &&
#================================================================================================================
# Convert the .sto file into .fa fasta files containing the amino acids

cd ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly/All_Iceland_proteins/All_Amino_acid_Seqs &&

for file in *.sto
do
assembly_id=${file%%.sto}
esl-reformat fasta > $assembly_id.fa ./$file
done &&
#================================================================================================================
#1Perform blastp search with the protein
# Verification/confirmation on the ncbi database
for i in *.faa
    do
    ~/ncbi-blast-2.13.0+/bin/blastp -query ${i} -db ~/proj/Resources/BLAST/NCBI/refseq_protein -max_target_seqs 5 -out ../blastp_out/${i}.txt -num_threads 5 -outfmt '6 qseqid salltitles sscinames sblastnames  sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore'
    done
#================================================================================================================
Verification/confirmation on the curated  database
for i in *.fa
    do
diamond blastp -d Funcgenes_51_Dec2021.dmnd -q $i -o Greening_lab_output_file.txt
done


# Perform blastp search with the protein #1 or back translate to nucleotide #2
#================================================================================================================











#================================================================================================================


mkdir ~/Peat_metagenome2022/Data/Single_assmbly2/All_Bins/All_Good_Bins/MOB/Nucleotide_seq &&

#2 backtranseq - Back-translate a protein sequence to a nucleotide sequence

for file in *.fa
do
assembly_id=${file%%.fa}
backtranseq -sequence ./$file -outfile ../Nucleotide_seq/$assembly_id.fasta
done &&
#================================================================================================================
cd ~/Peat_metagenome2022/Data/Single_assmbly2/HMMSEARCH/Nucleotide_seq &&
# Remove _amino-acid-sequences from each of the files

for file in *.fasta
do
  new_name=${file/_final.contigs.fasta.proteins/}
  mv "$file" "$new_name"
done &&
#================================================================================================================
# *****************************NOT USED***************************************
# Add file name to the header of each file 
#    perl -i -0777 -pe ' $x=$ARGV;$x=~s/\.fasta//g; s/\>/>${x}_/ ' *fasta 

# https://stackoverflow.com/questions/64558318/add-filename-to-fasta-headers-in-a-loop-with-awk/64562133#64562133

# Concatinate all files
#    for i in *.fasta;do cat $i >> All_MOB_genes.fasta;done
#================================================================================================================
# Activate coverm with conda
#    conda activate coverm

mkdir ~/Peat_metagenome2022/Data/Single_assmbly2/HMMSEARCH/CoverM_output &&

cd ~/Peat_metagenome2022/Data/Single_assmbly2/HMMSEARCH/Nucleotide_seq &&
# Loop through the fasta files
for i in *.fasta          
do
# Run the coverm contig command
coverm contig --coupled ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0008E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0008E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0009E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0009E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0010E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0010E_R2.fastq -r ${i} -o ../CoverM_output/"$i".output.tsv -m mean rpkm tpm --threads 60
done


#coverm contig --coupled ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R2.fastq -r Nucleotide_seq/xmoB.7E.fasta -o CoverM_output/CoverM_output2.tsv -m rpkm tpm --threads 40

#coverm contig --coupled ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R2.fastq -r Nucleotide_seq/xmoC.7E.fasta -o CoverM_output/CoverM_output2.tsv -m rpkm tpm --threads 40

#coverm contig --single ~/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0007E.fastq -r Nucleotide_seq2/all_mdh.7E.fasta -o CoverM_output/CoverM_output1.tsv -m rpkm tpm --threads 20






