#!/bin/sh

#Script to map ddRADseq reads that have been processed with process_radtags.pl
#requires: bowtie2
#TNM 08/1/2024

#SBATCH --job-name=Map40
#SBATCH -c 16
#SBATCH --mem=128G
#SBATCH --qos=high
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=30:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu
#SBATCH --array=1-167

line=$(sed -n "$SLURM_ARRAY_TASK_ID"p /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/all_samples.txt)

cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp
mkdir -p sorted_bams_quinqs-bowtie_PairedOnly

echo "File 1: $line.1.paired.fq.gz"
echo "File 2: $line.2.paired.fq.gz"

#echo "File 1 unpaired: $line.1.unpaired.fq.gz"
#echo "File 2 unpaired: $line.2.unpaired.fq.gz"

bowtie2 -x /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/CquiJHB2020_genome/CquiJHB2020 \
-1 $line.1.paired.fq.gz -2 $line.2.paired.fq.gz \
-U $line.1.unpaired.fq.gz,$line.2.unpaired.fq.gz \
--dovetail \
-p 16 | samtools sort -@ 16 -o ./sorted_bams_quinqs-bowtie_test1/$line.sorted.bam
