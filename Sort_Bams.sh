#!/bin/sh

#Script to sort bam files
#requires: samtools
#TNM 07/11/2024

#SBATCH --job-name=Sort40
#SBATCH -c 8
#SBATCH --mem=24G
#SBATCH --qos=medium
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=10:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu
#SBATCH -o ./sbatch_logs-Sort/%A_%a.out
#SBATCH -e ./sbatch_logs-Sort/%A_%a.err
#SBATCH --array=1-167

line=$(sed -n "$SLURM_ARRAY_TASK_ID"p /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/all_samples.txt)

#make a directory called "sorted_bams" on same level as "unsorted_bams"
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/
mkdir -p sorted_bams

#then move into unsorted_bams to run the command
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/unsorted_bams

#Sort bams
echo "Input: $line.bam"
echo "Output: $line.sorted.bam"
samtools sort -O bam -o ../sorted_bams/$line.sorted.bam $line.bam

#echo "Moving sorted bam..."
#mv $line.sorted.bam ../sorted_bams

echo "Done."
