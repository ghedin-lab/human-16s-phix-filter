#!/bin/bash
#PBS -l walltime=72:00:00,nodes=1:ppn=1,mem=62gb
#PBS -M twaddlac@gmail.com
#PBS -m ae
#PBS -j oe

# run it like this: qsub -v fastq=samplename filter.sh
# modufy path, exec_path, and '.gz' extension if need be

module load deconseq
module load prinseq
module load sortmerna
module load biopython

# change this to where your fastq files are
cd $path

#fastq="34211-2"

# set this to the directory where the custom python scripts are located. Will hopefully automate this later
exec_path="/path/to/executable/directory"

# make sure the fastq files have the naming scheme "sample-name.r1.fastq.gz"
# these can be uncompressed as well, just remove the .gz below if they are
python $exec_path/interleave-fastq.py $fastq.r1.fastq.gz $fastq.r2.fastq.gz > $fastq.interleaved.fastq

# command used to index provided rRNA dbs indexdb_rna -m 30000 --ref rfam-5.8s-database-id98.fasta,rfam-5.8s-database-id98.db:rfam-5s-database-id98.fasta,rfam-5s-database-id98.db:silva-arc-16s-id95.fasta,silva-arc-16s-id95.db:silva-arc-23s-id98.fasta,silva-arc-23s-id98.db:silva-bac-16s-id90.fasta,silva-bac-16s-id90.db:silva-bac-23s-id98.fasta,silva-bac-23s-id98.db:silva-euk-18s-id95.fasta,silva-euk-18s-id95.db:silva-euk-28s-id98.fasta,silva-euk-28s-id98.fasta

sortDB="/scratch/at120/shared/db/human-16s-for-filtering/sortmerna-db"

sortmerna \
--otu_map \
-a 20 \
-m 4096 \
--sam \
--paired_in \
--aligned $fastq.rRNA \
--other $fastq.non-rRNA \
--fastx \
--de_novo_otu \
--log \
--reads $fastq.interleaved.fastq \
--ref \
$sortDB/rfam-5.8s-database-id98.fasta,$sortDB/rfam-5.8s-database-id98.db:\
$sortDB/rfam-5s-database-id98.fasta,$sortDB/rfam-5s-database-id98.db:\
$sortDB/silva-arc-16s-id95.fasta,$sortDB/silva-arc-16s-id95.db:\
$sortDB/silva-arc-23s-id98.fasta,$sortDB/silva-arc-23s-id98.db:\
$sortDB/silva-bac-16s-id90.fasta,$sortDB/silva-bac-16s-id90.db:\
$sortDB/silva-bac-23s-id98.fasta,$sortDB/silva-bac-23s-id98.db:\
$sortDB/silva-euk-18s-id95.fasta,$sortDB/silva-euk-18s-id95.db:\
$sortDB/silva-euk-28s-id98.fasta,$sortDB/silva-euk-28s-id98.db

#command to index deconseq db: bwa64 index -a bwtsw hg19-silva_16s-phix.fasta

# deconseq doesn't handle paired end data so this will be run last?
#deconseq.pl -f $fastq.non-rRNA.fastq 

prinseq-lite.pl \
-fastq $fastq.non-rRNA.fastq \
-out_format 3 \
-out_good $fastq.non-rRNA.prinseq_good \
-out_bad $fastq.non-rRNA.prinseq_bad \
-lc_threshold 15 \
-lc_method dust \
-no_qual_header \
-range_len 50,300 \
-min_qual_mean 25 \
-ns_max_p 10 \
-derep 12 \
-trim_qual_right 20 \
-trim_qual_type min  \
-trim_qual_window 1 \
-trim_qual_step 1 \
-trim_qual_rule lt \
-stats_all > $fastq.non-rRNA.prinseq.stats.txt

python $exec_path/extract-paired-reads-from-one-file.py $fastq.non-rRNA.prineq_good.fastq

