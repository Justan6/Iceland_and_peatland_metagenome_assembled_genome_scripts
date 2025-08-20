#!/bin/bash -   
#title          :Profiling.sh
#description    :For sequence annotation 
#author         :Justus Nweze
#date           :20210429
#version        :
#usage          :
#==============================================================================================

logFile="16_Assign_taxaonomy_MAG.log"

conda activate gtdbtk-1.2.0_1
export GTDBTK_DATA_PATH=~/proj/Resources/release214/ 
gtdbtk classify_wf --cpus 2 -x fasta --genome_dir Genome --out_dir PHYLOGENO_GTDB_Bin



# convert_to_itol
# The convert_to_itol command will remove internal labels from Newick tree, making it suitable for visualization in iTOL

# gtdbtk convert_to_itol --input_tree INPUT_TREE --output_tree OUTPUT_TREE

gtdbtk convert_to_itol --input_tree gtdbtk.bac120.classify.tree.7.tree --output_tree iTOL/gtdbtk.bac120.classify.tree.7_for_itol.tree

gtdbtk convert_to_itol --input_tree gtdbtk.backbone.bac120.classify.tree --output_tree iTOL/gtdbtk.backbone.bac120.classify_for_itol.tree















#Activate anvio-7 before running this script

# Change directory to data folder
	cd ~/nwezejus/Peat_metagenome2022/Data

# Refine the bins

anvi-refine -p DATABASE/PROFILE.db -c CONTIGS/contigs.db -C metabat2 -b Refined_bin/7_MetaBAT_bin.53.fa

cp -r 1ForRev/trimmed_fastq/JMF-2110-11-0010E_R2.trim.fastq trimmed_fastq

export GTDBTK_DATA_PATH=/home/nwezejus/release207_v2/


wget -r -np -nH --cut-dirs=3 -R index.html http://https://data.ace.uq.edu.au/public/gtdbtk/release95/markers/pfam/individual_hmms/

# Taxonomical identification of MAGs https://ecogenomics.github.io/GTDBTk/examples/classify_wf.html and https://gitlab.ifremer.fr/rimicaris/rimicaris-exoculata-cephalothoracic-epibionts-metagenomes/-/blob/28d4e3faf373b279c70a0ec5918a559560a81f24/README.md and https://github.com/cerebis/GtdbTk#quick-start https://merenlab.org/2019/10/08/anvio-scg-taxonomy/
# Taxonomic assignments of our MAGs was made with GTDB-Tk based on the Genome Database Taxonomy GTDB
# For single assembly (megahit)



    conda activate gtdbtk-1.2.0_1
    export GTDBTK_DATA_PATH=/home/nwezejus/release207_v2/


gtdbtk classify_wf --cpus 5 -x fa --genome_dir DASTool_Bin/_DASTool_bins --out_dir PHYLOGENO_GTDB_MAGs

gtdbtk classify_wf --cpus 5 -x fna --genome_dir Bins2 --out_dir PHYLOGENO_GTDB_MAGs

gtdbtk ani_rep --cpus 5 -x fna --genome_dir Bins --out_dir PHYLOGENO_ani_rep

#Identify marker genes in genome(s).
gtdbtk identify --cpus 5 -x fna --genome_dir Bins --out_dir PHYLOGENO_identify


gtdbtk convert_to_itol --input_tree gtdbtk.bac120.classify.tree.4.tree --output_tree OUTPUT_gtdbtk.bac120.classify.tree.4.tree

gtdbtk convert_to_itol --input_tree gtdbtk.backbone.bac120.classify.tree --output_tree OUTPUT_gtdbtk.backbone.bac120.classify.tree



gtdbtk classify_wf --cpus 5 -x fa --genome_dir GENOMES  --out_dir PHYLOGENO_GTDB_MAGs









# The alignment was cleaned up by removing positions that were gap characters in more than 50% of the sequences using trimAL
# Make a director PHYLOGENO_GTDB/anvio_tree
	 mkdir PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree
# # Make tree with the MSA file from gtdb_tk
	trimal -in PHYLOGENO_GTDB/classify_wf_output_concoct/align/gtdbtk.bac120.msa.fasta -out PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/gtdbtk_bac120_msa_anvio_clean.fasta -gt 0.50

# And we built a maximum likelihood tree using IQ-TREE with the 'WAG' general matrice model.
	iqtree -s PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/gtdbtk_bac120_msa_anvio_clean.fasta -nt 8 -m WAG -bb 1000
	
# Now we have a newick tree that shows our MAG with the closest GTDB genomes. We used the anvi’o interactive interface to visualize this new tree:
	anvi-interactive -p PHYLOGENO_GTDB/classify_wf_output_metabat2/anvio_tree/phylogenomic-profile.db -t PHYLOGENO_GTDB/classify_wf_output_metabat2/anvio_tree/gtdbtk_bac120_msa_anvio_clean.fasta.contree --title "Phylogenomics Tree from Metabat2 bins" --manual

# To improve the visualization, we prepared a collection file that describes the sources of the genomes and we imported it for the anvi'o interactive interface
	grep "^>" PHYLOGENO_GTDB/classify_wf_output_concoct/align/gtdbtk.bac120.msa.fasta \
          | awk -F" " '{print $1}' | sed 's/>//g' | while read NAME
do
    if [[ "$NAME" == *MAG* ]]
    then echo -e $NAME"\tMAG" >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/source_collection.txt
    else echo -e $NAME"\tGTDB" >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/source_collection.txt
    fi
done

# The following output provides a glimpse from the file source_collection.txt
	head PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/source_collection.txt

# We used the program anvi-import-collection to import this information back into the anvi’o profile databases.
	anvi-import-collection PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/source_collection.txt -p PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/phylogenomic-profile.db -C Source


# We prepared a matrix to add phylum level information for all the tree branches and family or genus level if it's identical to the taxonomy of our MAGs
	echo -e "genome_id\tPhyla\tFamilies\tGenera" > PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt

# Add the taxonomy of our MAGs
tail -n +2 PHYLOGENO_GTDB/classify_wf_output_concoct/gtdbtk.bac120.summary.tsv | while read line
do
    NAME=`echo $line | awk -F" |;" '{print $1}'`
    PHYLUM=`echo $line | awk -F" |;" '{print $3}' | sed 's/.__//g'`
    FAMILY=`echo $line | awk -F" |;" '{print $6}' | sed 's/.__//g'`
    GENUS=`echo $line | awk -F" |;" '{print $7}' | sed 's/.__//g'`
    echo -e $NAME"\t"$PHYLUM"\t"$FAMILY"\t"$GENUS >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt
done

# Prepare lists with MAGs taxonomy at the genus and family level
awk -F";" '{print $5}' PHYLOGENO_GTDB/classify_wf_output_concoct/gtdbtk.bac120.summary.tsv \
    | sed 's/.__//g' | sed '/^$/d' | uniq | tr -d '\n' >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/taxa_to_keep.txt
awk -F";" '{print $6}' PHYLOGENO_GTDB/classify_wf_output_concoct/gtdbtk.bac120.summary.tsv \
    | sed 's/.__//g' | sed '/^$/d' | uniq | tr -d '\n' >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/taxa_to_keep.txt

# Add the taxonomy of the GTDB genomes at the phylum level and at the genus or family level if it is identical
# to the taxonomy of our MAGs
grep "^>" PHYLOGENO_GTDB/classify_wf_output_concoct/align/gtdbtk.bac120.msa.fasta | sed 's/>//g' | while read line
do
    for TAX_MAG in `cat PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/taxa_to_keep.txt`
    do
        NAME=`echo $line | awk -F" |;" '{print $1}'`
        PHYLUM=`echo $line | awk -F" |;" '{print $3}' | sed 's/.__//g'`    
        FAMILY=`echo $line | awk -F" |;" '{print $6}' | sed 's/.__//g'`
        GENUS=`echo $line | awk -F" |;" '{print $7}' | sed 's/.__//g'`
        if [[ "$NAME" == *MAG* ]]
        then 
            continue 
        elif [[ "$TAX_MAG" =~ "$FAMILY" ]] && [[ "$TAX_MAG" =~ "$GENUS" ]]
        then
            echo -e $NAME"\t"$PHYLUM"\t"$FAMILY"\t"$GENUS >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt
        elif [[ "$TAX_MAG" =~ "$FAMILY" ]]
        then
            echo -e $NAME"\t"$PHYLUM"\t"$FAMILY"\t" >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt
        else
            echo -e $NAME"\t"$PHYLUM"\t\t" >> PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt
    fi
    done
done

# The following output provides a glimpse from the file view_data.txt:
	head PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt 

# Finally used the program anvi-misc-data to import this information back into the anvi’o profile databases.
	anvi-import-misc-data PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/view_data.txt -p 09_PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/phylogenomic-profile.db --target-data-table items

# We visualized our tree in the interactive interface of anvio
	anvi-interactive -p PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/phylogenomic-profile.db \
                 -t PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree/gtdbtk_bac120_msa_anvio_clean.fasta.contree \
                 --title "Phylogenomics Tree from Concoct bins" \
                 --manual

# Generate anvi'o static image
# For the anvi'o static image of the MAG we built a phylogenomic tree including only our MAG:
	mkdir -p PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree_MAG

trimal -in 0PHYLOGENO_GTDB/classify_wf_output_concoct/gtdbtk.bac120.user_msa.fasta \
       -out PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree_MAG/gtdbtk_bac120.user_msa_anvio_clean.fasta \
       -gt 0.50 

iqtree -s PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree_MAG/gtdbtk_bac120.user_msa_anvio_clean.fasta \
       -nt 8 \
       -m WAG \
       -bb 1000
anvi-interactive -t PHYLOGENO_GTDB/classify_wf_output_concoct/anvio_tree_MAG/gtdbtk_bac120.user_msa_anvio_clean.fasta.contree \
                 -p 12_TABLES/profile.db \
                 --title "anvi'o static image" \
                 --manual





# Comparing multiple binning approaches https://merenlab.org/tutorials/infant-gut/#importing-an-external-binning-result
# The simplest way to do it is to assume a ‘true organization of contigs’, and then investigate every other approach with respect to that:
# (1) the organization of contigs based on hierarchical clustering analysis, (2) per-contig taxonomy estimated from the gene-level taxonomic annotations by Centrifuge


# https://academic.oup.com/bib/article/22/5/bbab030/6184411
