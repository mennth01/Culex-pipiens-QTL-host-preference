#!/bin/sh

# Script to format files for gemma analysis and impute genotypes
# Adapted from script provided by Kate Taylor
# requires: plink and LinkImpute (both downloaded and unzipped, NOT in conda environment)
# TNM 10/29/2025

#SBATCH --job-name=SetupQ
#SBATCH -c 1
#SBATCH --mem=8G
#SBATCH --qos=default
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=10:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu

## Move into the proper directory:
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/sorted_bams_quinqs-bowtie_test1/genotype_calls
mkdir -p unimputed

## Prepare files for gemma analysis

~/programs/plink_program/plink \
--vcf hostprefQTL-QuinqsT.filtered-variants.vcf.recode.vcf \
--make-bed --out ./unimputed/hostprefQTL-QuinqsT \
--allow-extra-chr --const-fid "progeny"

cd ./unimputed

~/programs/plink_program/plink \
--bfile hostprefQTL-QuinqsT --const-fid "progeny" --allow-extra-chr --allow-no-sex \
--pheno /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/all_phenotype.sorted.bam.txt \
--make-bed --out ALL-QuinqsT

## Format Unimputed file for gemma
~/programs/plink_program/plink \
--bfile ALL-QuinqsT \
--allow-no-sex \
--allow-extra-chr \
--keep /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/F2s.sorted.bam.txt \
--make-bed \
--out hostprefQTL-QuinqsT_offspring_gemma

## Sanity checks

~/programs/plink_program/plink --bfile hostprefQTL-QuinqsT_offspring_gemma --allow-extra-chr --allow-no-sex --missing
~/programs/plink_program/plink --bfile hostprefQTL-QuinqsT_offspring_gemma --allow-extra-chr --allow-no-sex --freq
