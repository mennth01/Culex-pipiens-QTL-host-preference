#!/bin/sh

#Script to call genotypes
#requires: bcftools, vcftools
#TNM 10/29/2025

#SBATCH --job-name=Call
#SBATCH -c 16
#SBATCH --mem=64G
#SBATCH --qos=high
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=23:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu

#Move into the proper directory:

cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/demult_reads-C-noTrim-MseI/trimmed_40bp/sorted_bams_quinqs-bowtie_test1/
mkdir -p genotype_calls

echo "Running mpileup..."

#Call genotypes: Note that the filename_list is one where samples with too few reads have been removed
bcftools mpileup --threads 16 \
-f /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/CquiJHB2020_genome/VectorBase-61_CquinquefasciatusJHB2020_Genome.fasta \
-b /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL/filename_lists/filtered_sorted_bams.txt \
-I -Oz -q 20 -o ./genotype_calls/hostprefQTL_QuinqsT_mpileup.vcf

echo "Running bcftools call..."
cd ./genotype_calls
bcftools call --threads 16 -vmO z -o hostprefQTL-QuinqsT.total-variants.vcf \
hostprefQTL_QuinqsT_mpileup.vcf

echo "Running vcftools..."

vcftools --vcf hostprefQTL-QuinqsT.total-variants.vcf --recode \
--out hostprefQTL-QuinqsT.filtered-variants.vcf \
--minDP 10 --min-alleles 2 --max-alleles 2 --maf 0.05 --max-missing 0.75

echo "done."
