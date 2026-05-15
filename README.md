# Culex-pipiens-QTL-host-preference
Raw sequencing reads processed with:
  1. Demult.sh -- barcodes found in 4 files <Idx1_barcodes.C-fixed.tsv> <Idxs_barcodes.C-fixed.tsv> <Idx6_barcodes.C-fixed.tsv> and <Idx12_barcodes.C-fixed.tsv>
  2. Trimmomatic.sh -- with custom adaptor file for trimming <TruSeq3-PE-2_prefixTTA.fa>
  3. Map_Reads.sh -- with bowtie2
  4. Sort_Bams.sh
Genotypes called using "Call_Genotypes.sh"
Output formatted for GEMMA with "Setup_for_Gemma.sh"
QTL analysis run with Gemma.sh -- (Output is "LMM-hostprefQTL-QuinqsT.assoc.txt")

* Behavioral Analysis: "behavioral_analysis.Rmd"
* QTL summary and analysis of GEMMA output: "QTL_analysis_LMM.Rmd"
* Calculation of F for heterozygosity analysis: "heterozygosity_analysis.R"
* LD Decay:
    1. r2 calculated for pairs of SNPs with __ -- (Output is "hostpref_LD_r2.ld")
    2. LD decay/half-life calculated and plotted in "LD_analysis_updated.R"
    3. "LD_prune.sh" used to prune SNPs based on LD for PCA -- (Output is "hostpref_PCA_ready.raw")
* Partial RDA analysis: "partial_RDA_analysis.Rmd"
