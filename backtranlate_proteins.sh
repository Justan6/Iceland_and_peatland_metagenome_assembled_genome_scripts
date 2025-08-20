#!/bin/bash

for i in *.fa; do
    backtranseq -sequence "$i" -outfile "../Extracted_gene_seqs/$i"
done

