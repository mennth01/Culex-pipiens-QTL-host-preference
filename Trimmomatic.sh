#!/bin/sh

#Script to trim reads with Trimmomatic after filtering
#requires: trimmomatic
#TNM 08/01/2024

#SBATCH --job-name=Trim40
#SBATCH -c 4
#SBATCH --mem=16G
#SBATCH --qos=default
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=20:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu
#SBATCH -o ./sbatch_logs-Trimmomatic_40bp/%A_%a.out
#SBATCH -e ./sbatch_logs-Trimmomatic_40bp/%A_%a.err
#SBATCH --array=1-167

line=$(sed -n "$SLURM_ARRAY_TASK_ID"p /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/all_samples.txt)


cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI
mkdir -p trimmed_40bp

echo "R1, paired: $line.1.fq.gz"
echo "R2, paired: $line.2.fq.gz"

trimmomatic PE $line.1.fq.gz $line.2.fq.gz \
./trimmed_40bp/$line.1.paired.fq.gz ./trimmed_40bp/$line.1.unpaired.fq.gz \
./trimmed_40bp/$line.2.paired.fq.gz ./trimmed_40bp/$line.2.unpaired.fq.gz \
ILLUMINACLIP:/fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/barcodes/TruSeq3-PE-2_prefixTTA.fa\
:2:10:10:8:true SLIDINGWINDOW:5:20 MINLEN:40 \
-trimlog ./trimmed_40bp/$line.trimlog -summary ./trimmed_40bp/$line.summary

echo "Done."
