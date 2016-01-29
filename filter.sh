#!/bin/bash
#PBS -l walltime=168:00:00,nodes=1:ppn=20,mem=62gb
#PBS -M twaddlac@gmail.com
#PBS -m ae
#PBS -j oe

module load deconseq
module load prinseq
module load sortmerna

cd $path

# command used to index provided rRNA dbs indexdb_rna -m 30000 --ref rfam-5.8s-database-id98.fasta,rfam-5.8s-database-id98.db:rfam-5s-database-id98.fasta,rfam-5s-database-id98.db:silva-arc-16s-id95.fasta,silva-arc-16s-id95.db:silva-arc-23s-id98.fasta,silva-arc-23s-id98.db:silva-bac-16s-id90.fasta,silva-bac-16s-id90.db:silva-bac-23s-id98.fasta,silva-bac-23s-id98.db:silva-euk-18s-id95.fasta,silva-euk-18s-id95.db:silva-euk-28s-id98.fasta,silva-euk-28s-id98.fasta

sortmerna \
--otu-map on \
--num_alignments 1 \
--sam \
--paired on \
--aligned $fastq.rRNA \
--other $fastq.non-rRNA \
--fastx \
--de_novo_oty on \
--log $fastq.log \
--reads $fastq.fastq \
--ref rfam-5.8s-database-id98.fasta,rfam-5.8s-database-id98.db:rfam-5s-database-id98.fasta,rfam-5s-database-id98.db:silva-arc-16s-id95.fasta,silva-arc-16s-id95.db:silva-arc-23s-id98.fasta,silva-arc-23s-id98.db:silva-bac-16s-id90.fasta,silva-bac-16s-id90.db:silva-bac-23s-id98.fasta,silva-bac-23s-id98.db:silva-euk-18s-id95.fasta,silva-euk-18s-id95.db:silva-euk-28s-id98.fasta,silva-euk-28s-id98.fasta

#command to index deconseq db: bwa64 index -a bwtsw hg19-silva_16s-phix.fasta

# deconseq doesn't handle paired end data so this will be run last?
deconseq -f $fastq.fastq 
