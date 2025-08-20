#!/bin/bash -   
#title          :Assembly.sh
#description    : build hmm files from protein files
#author         :Justus Nweze
#date           :2023.9.8
#usage          :Run the command
#===========================================================================================================

#!/bin/bash

# Set the source directory (database_files) and destination directory (hmm_files)
source_dir="database_files"
dest_dir="hmm_files"

# Create the destination directory if it doesn't exist
mkdir -p "$dest_dir"

# Iterate over all .fasta files in the source directory
for fasta_file in "$source_dir"/*.fasta; do
    # Extract the file name without extension
    base_name=$(basename -- "$fasta_file")
    base_name_no_ext="${base_name%.*}"

    # Build the HMM file using hmmbuild
    hmm_file="$dest_dir/$base_name_no_ext.hmm"
    hmmbuild "$hmm_file" "$fasta_file"

    echo "Created $hmm_file"
done








