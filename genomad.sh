#!/bin/bash -   
#title          :Assembly.sh
#description    :A simple loop to serially map all samples
#author         :Justus Nweze
#date           :20210429
#version        :Referenced from within http://merenlab.org/tutorials/assembly_and_mapping
#usage          :Run the command
#===========================================================================================================

conda activate genomad

genomad annotate --cleanup final.contigs.fasta A1_output ~/proj/Resources/geNomad_Database/genomad_db

#================================================================================================================
# extract gene Ids from final.contigs_genes.tsv output from genomad annotate with

#!/bin/bash

# Input file
input_file="final.contigs_genes.tsv"

# Output file for extracted genes (including header)
output_file="methane_genes_with_context.tsv"

# Check if the output file already exists and remove it if it does
if [ -e "$output_file" ]; then
    rm "$output_file"
fi

# Search for lines containing "methane" in the annotation_description column
grep -ni "methane" "$input_file" | while read -r line; do
    line_number=$(echo "$line" | cut -d ':' -f 1)
    context_start=$((line_number - 3))
    context_end=$((line_number + 3))

    # Extract the context rows using head and tail
    head -n "$context_end" "$input_file" | tail -n +"$context_start" >> "$output_file"
done

echo "Rows with 'methane' in the annotation_description column and their context have been extracted to '$output_file'."

#================================================================================================================
#OR
#    mkdir All_proteins &&

#    find Genomad_output -type f -name '*_final.contigs_genes.tsv' -exec cp {} All_proteins/ \;
#================================================================================================================
# Filter out unnessary rows to reduce the file

#!/bin/bash

# Set the input and output directories
input_dir="All_proteins"
output_dir="All_proteins/Filter"

# Loop through all .tsv files in the input directory
for input_file in "$input_dir"/*.tsv; do
    # Extract the filename without extension
    filename=$(basename "$input_file" .tsv)
    
    # Define the output file path
    output_file="$output_dir/$filename.tsv"
    
     # Use awk to filter the file based on two conditions
    # - Exclude rows where column 16 ("taxname") contains "Caudoviricetes"
    # - Exclude rows where columns 19 and 20 contain "NA"
    awk -F'\t' '$16 != "Caudoviricetes" && $19 != "NA" && $20 != "NA"' "$input_file" > "$output_file"
done

#================================================================================================================







# Copy al the gen ID and save it in a 

seqtk subseq final.contigs_proteins.faa GeneIDs.txt > Methane_genes.fa


for i in *.fa
    do
    ~/ncbi-blast-2.13.0+/bin/blastp -query ${i} -db ~/proj/Resources/BLAST/NCBI/refseq_protein -max_target_seqs 5 -out blastp_out/${i}.txt -num_threads 5 -outfmt '6 qseqid salltitles sscinames sblastnames  sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore'
    done
#================================================================================================================
# Verification/confirmation on the curated  database
diamond blastp --db ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Database/Funcgenes_51_Dec2021.dmnd -q Methane_genes.fa -o Greening_lab_output_file.txt

diamond blastp -d ~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Database/Funcgenes_51_Dec2021.dmnd -q Methane_genes.fa -o Greening_lab_output_file2.txt --evalue 0.001








#!/bin/bash

# Path to the Diamond database (replace with the actual path)
db_path="~/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Database/Funcgenes_51_Dec2021.dmnd"

# Iterate through all .fa files in the current directory
for i in *.fa
do
    # Generate a unique output filename based on the input filename
    output_file="output_${i%.fa}.txt"

    # Run Diamond BLASTP with the corrected database path and unique output filename
    diamond blastp -db "$db_path" -q "$i" -o "$output_file"
done











































