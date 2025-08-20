# Iceland and Peatland Metagenome-Assembled Genome (MAG) Workflow

This project provides a reproducible workflow to reconstruct **metagenome-assembled genomes (MAGs)** from a single site, including Icelandic hot springs and peatlands. The workflow covers all key steps from raw metagenome data to functional annotation and metabolic profiling.

## Workflow Overview

The workflow consists of the following steps:

1. **Data Preparation**  
   Convert raw sequencing data (e.g., BAM files) to paired-end FASTQ format for downstream analysis.

2. **Quality Filtering**  
   - Perform quality checks using **FastQC**.  
   - Trim low-quality bases and adapter sequences using **Trimmomatic** or **fastp**.

3. **Assembly**  
   Assemble high-quality reads into contigs using **MEGAHIT**.

4. **Mapping**  
   - Map quality-filtered reads back to the assembled contigs using **Bowtie2**.  
   - Convert SAM files to BAM format and index for coverage and depth analysis.

5. **Binning**  
   - Bin contigs into MAGs based on sequence composition and coverage using **MetaBAT2**, **MaxBin**, and **Concoct**.  
   - Combine results into a non-redundant set of bins with **DAStool**.

6. **Quality Assessment**  
   Assess completeness and contamination of MAGs with **CheckM**.

7. **Taxonomic and Phylogenetic Analysis**  
   - Assign taxonomy using **GTDB-Tk (classify_wf)** based on the GTDB database.  
   - Identify marker genes with **GTDB-Tk (identify)**.  
   - Perform comparative analyses against reference genomes in GTDB.

8. **Functional Annotation and Metabolic Profiling**  
   Annotate MAGs and infer metabolic potential using:  
   - **DRAM**: functional annotation using KEGG, UniRef90, PFAM, and metabolic summaries.  
   - **METABOLIC**: prediction of biogeochemical functional traits and elemental cycling pathways.  
   - **CoverM**: calculate genome coverage and estimate relative abundance in the community.  
   - **KEGGCharter**: visualize metabolic potential on KEGG maps, including pathways like methane metabolism.

## Repository Contents

- `scripts/` – Scripts used for assembly, binning, mapping, and annotation.  
- `metadata/` – Sample metadata and sequencing information.  
- `README.md` – This file describing the workflow and repository structure.

## Citation

Please cite this repository when using the workflow or scripts for metagenomic MAG reconstruction and analysis.

---

This workflow is designed to facilitate reproducible analysis of MAGs from complex environmental datasets, providing a complete pipeline from raw reads to functional and taxonomic characterization.
