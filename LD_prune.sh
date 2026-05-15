#!/bin/sh

# Script to prune SNPs prior to performing PCA for a partial RDA
# requires: plink
# TNM 1/15/2025

#SBATCH --job-name=LD_Prune
#SBATCH -c 1
#SBATCH --mem=64G
#SBATCH --qos=medium
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=10:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu

## Move into the proper directory:
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/sorted_bams_quinqs-bowtie_test1/genotype_calls/

echo "Step 1: Convert VCF to Binary and Fix IDs..."
# --set-missing-var-ids @:# replaces "." IDs with "Chromosome:Position"
# This ensures every SNP has a unique, trackable name.
plink --vcf hostprefQTL-QuinqsT.filtered-variants.vcf.recode.vcf --allow-extra-chr --set-missing-var-ids @:# --make-bed --out hostpref_all_snps

echo "Starting LD pruning..."

## STEP 1: Identify the SNPs to prune (One single line)
plink --bfile hostpref_all_snps --allow-extra-chr --indep-pairwise 50 10 0.2 --out hostpref_pruning_list

##Generate the new dataset (One single line)
plink --bfile hostpref_all_snps --allow-extra-chr --extract hostpref_pruning_list.prune.in --make-bed --out hostpref_pruned_for_PCA

# --recode A exports the data as an additive model (0/1/2) --bfile tells PLINK to read your binary .bed/.bim/.fam files
plink --bfile hostpref_pruned_for_PCA --allow-extra-chr --recode A --out hostpref_PCA_ready

echo "Done. Use hostpref_PCA_ready.raw"
