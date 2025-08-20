#    DESCRIPTION

#    coverm genome calculates the coverage of a set of reads on a set of genomes.

# This process can be undertaken in several ways, for instance by specifying BAM files or raw reads as input, defining genomes in different input formats, dereplicating genomes before mapping, using different mapping programs, thresholding read alignments, using different methods of calculating coverage and printing the calculated coverage in various formats.

    conda activate coverm 

# Map paired reads to 2 genomes, and output relative abundances to output.tsv

#    coverm genome --coupled read1.fastq.gz read2.fastq.gz --genome-fasta-files genome1.fna genome2.fna -o output.tsv -t 20

mkdir CoverM_output
coverm genome --single ~/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0007E.fastq -x fasta -d Bins/7E.fasta -o CoverM_output/7E_output.tsv --threads 20 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0008E.fastq -x fasta -d Bins/8E -o CoverM_output/8E_output.tsv --threads 5 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0009E.fastq -x fasta -d Bins/9E -o CoverM_output/9E_output.tsv --threads 5 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0010E.fastq -x fasta -d Bins/10E -o CoverM_output/10E_output.tsv --threads 5


for i in *.fasta          
do
coverm contig --coupled ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0007E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0008E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0008E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0009E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0009E_R2.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0010E_R1.fastq ~/Peat_metagenome2022/Data/Single_fastq/ForRev/raw_fastq/JMF-2110-11-0010E_R2.fastq -r ${i} -o ../CoverM_output/"$i".output.tsv -m mean rpkm tpm -p bwa-mem --threads 40
done


coverm genome --single ~/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0007E.fastq -x fasta -d MAG1_JAN1.fa -o CoverM_output/7E_output.tsv --threads 20 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0008E.fastq -x fasta -d Bins/8E -o CoverM_output/8E_output.tsv --threads 5 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0009E.fastq -x fasta -d Bins/9E -o CoverM_output/9E_output.tsv --threads 5 &&

coverm genome --single ../../../Single_fastq/JMF-2110-11-0010E.fastq -x fasta -d Bins/10E -o CoverM_output/10E_output.tsv --threads 5


coverm genome --single /proj/Peat_soil/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0007E.fastq -x fasta -d Genome -o CoverM_output/7E_output.tsv --threads 10 &&

coverm genome --single /proj/Peat_soil/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0008E.fastq -x fasta -d Genome -o CoverM_output/8E_output.tsv --threads 10 &&

coverm genome --single /proj/Peat_soil/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0009E.fastq -x fasta -d Genome -o CoverM_output/9E_output.tsv --threads 10 &&

coverm genome --single /proj/Peat_soil/Peat_metagenome2022/Data/Single_fastq/JMF-2110-11-0010E.fastq -x fasta -d Genome -o CoverM_output/10E_output.tsv --threads 10
