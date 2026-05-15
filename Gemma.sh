#!/bin/sh

# Script to run gemma using two types of models
# Adapted from script provided by Kate Taylor
# requires: gemma (conda environment)
# TNM 09/25/2024

# Gemma user guide: https://www.xzlab.org/software/GEMMAmanual.pdf

#SBATCH --job-name=GemmaQ
#SBATCH -c 1
#SBATCH --mem=64G
#SBATCH --qos=medium
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=10:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu

## Move into the proper directory:
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/sorted_bams_quinqs-bowtie_test1/genotype_calls/unimputed

## Run gemma lmm
## -lm 4 will run all three possible statistical tests:
##           Wald test, likelihood ratio test, and score test

echo "Running gemma lmm..."
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -lm 4 -o LMM-hostprefQTL-QuinqsT

## Run gemma bslmm (5x)
## -bslmm 1 fits a standard linear BSLMM

echo "Running gemma bslmm..."
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -bslmm 1 -o BSLMM-hostpref1-QuinqsT -w 500000 -s 5000000
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -bslmm 1 -o BSLMM-hostpref2-QuinqsT -w 500000 -s 5000000
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -bslmm 1 -o BSLMM-hostpref3-QuinqsT -w 500000 -s 5000000
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -bslmm 1 -o BSLMM-hostpref4-QuinqsT -w 500000 -s 5000000
gemma -bfile ./hostprefQTL-QuinqsT_offspring_gemma -bslmm 1 -o BSLMM-hostpref5-QuinqsT -w 500000 -s 5000000

echo "Done."
