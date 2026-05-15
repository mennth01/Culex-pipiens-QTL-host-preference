#!/bin/sh

#Script to demultiplex, filter, trim adaptors from ddRADseq reads
#requires: Stacks process_radtags
#TNM 07/15/2024

#SBATCH --job-name=Demult
#SBATCH -c 8
#SBATCH --mem=24G
#SBATCH --qos=medium
#SBATCH --partition=cbcb
#SBATCH --account=cbcb
#SBATCH --time=4:00:00
#SBATCH --mail-type=END
#SBATCH --mail-user=tmenna@umd.edu
#SBATCH -o ./sbatch_logs-Demult-C-noTrim-MseI/Demult_%A_%a.out
#SBATCH -e ./sbatch_logs-Demult-C-noTrim-MseI/Demult_%A_%a.err


#Run from this directory:
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL

# ** EcoRI Barcodes (as copied from plate arrangements recorded in lab notebook) **
# Idx1: Plate 8 [A1-5;B1-5;C1-5;D1-6;E1-6;F1-5;G1-5;H1-5]
# Idx2: Plate 8 [A6-11'B6-11;C6-11;D7-11;E7-10;F6-10;G6-10;H6-10]
# Idx6: Plate 8 [A12;B12;C12;D12;E11-12;F11-12;G11-12;H11-12] & Plate 3 [A-F,1-4; G-H,1-3]
# Idx12: Plate 3 [A-F,5-9; G4-9; H4-8]

#Run from this directory:
cd /fs/cbcb-lab/mfritz13/tmenna/hostpref_QTL
#mkdir demult_reads-C-noTrim-MseI

#Filter and demultiplex and trim with stacks pipeline
# May need to adjust (1) barcode filename and (2) output directory name "demult_and_trimmed-??"

echo "Processing Idx1 pool..."
#Idx1
process_radtags -1 ./raw_data/XFRIT_20240319_A00904_IL6472-001_LG07_L004_R1.fastq.gz -2 ./raw_data/XFRIT_20240319_A00904_IL6472-001_LG07_L004_R2.fastq.gz -b ./barcodes/Idx1_barcodes.C-fixed.tsv -o ./demult_reads-C-noTrim-MseI -e 'ecoRI' --renz-2 'mseI' -qD -y 'gzfastq' --inline_null --rescue --barcode-dist-1 1
stacks-dist-extract --pretty ./demult_reads-C-noTrim-MseI/process_radtags.raw_data.log per_barcode_raw_read_counts >&1 | tee ./demult_reads-C-noTrim-MseI/Idx1_per_barcode_readCounts.txt

echo "Processing Idx2 pool..."
#Idx2
process_radtags -1 ./raw_data/XFRIT_20240319_A00904_IL6473-001_LG08_L004_R1.fastq.gz -2 ./raw_data/XFRIT_20240319_A00904_IL6473-001_LG08_L004_R2.fastq.gz -b ./barcodes/Idx2_barcodes.C-fixed.tsv -o ./demult_reads-C-noTrim-MseI -e 'ecoRI' --renz-2 'mseI' -qD -y 'gzfastq' --inline_null --rescue --barcode-dist-1 1
stacks-dist-extract --pretty ./demult_reads-C-noTrim-MseI/process_radtags.raw_data.log per_barcode_raw_read_counts >&1 | tee ./demult_reads-C-noTrim-MseI/Idx2_per_barcode_readCounts.txt

echo "Processing Idx6 pool..."
#Idx6
process_radtags -1 ./raw_data/XFRIT_20240319_A00904_IL6474-001_LG10_L004_R1.fastq.gz -2 ./raw_data/XFRIT_20240319_A00904_IL6474-001_LG10_L004_R2.fastq.gz -b ./barcodes/Idx6_barcodes.C-fixed.tsv -o ./demult_reads-C-noTrim-MseI -e 'ecoRI' --renz-2 'mseI' -qD -y 'gzfastq' --inline_null --rescue --barcode-dist-1 1
stacks-dist-extract --pretty ./demult_reads-C-noTrim-MseI/process_radtags.raw_data.log per_barcode_raw_read_counts >&1 | tee ./demult_reads-C-noTrim-MseI/Idx6_per_barcode_readCounts.txt

echo "Processing Idx12 pool..."
#Idx12
process_radtags -1 ./raw_data/XFRIT_20240319_A00904_IL6475-001_LG15_L004_R1.fastq.gz -2 ./raw_data/XFRIT_20240319_A00904_IL6475-001_LG15_L004_R2.fastq.gz -b ./barcodes/Idx12_barcodes.C-fixed.tsv -o ./demult_reads-C-noTrim-MseI -e 'ecoRI' --renz-2 'mseI' -qD -y 'gzfastq' --inline_null --rescue --barcode-dist-1 1
stacks-dist-extract --pretty ./demult_reads-C-noTrim-MseI/process_radtags.raw_data.log per_barcode_raw_read_counts >&1 | tee ./demult_reads-C-noTrim-MseI/Idx12_per_barcode_readCounts.txt
