#!/bin/bash

# Specify the directory containing the .faa files
directory_path="/proj/Peat_soil/Iceland_deep_metagenome/Iceland_metagenome/Single_assembly/All_Iceland_proteins/Proteins_Seq"

# Iterate through .faa files in the directory
for file in "$directory_path"/*.faa; do
    # Extract the file name without extension
    filename=$(basename "$file" .faa)
    
    # Count the proteins using Python and print the result
    protein_count=$(python -c "with open('$file', 'r') as f:
        lines = f.readlines()
        count = sum(1 for line in lines if line.startswith('>'))
        print(count)")
    
    echo "File: $filename, Protein Count: $protein_count"
done

