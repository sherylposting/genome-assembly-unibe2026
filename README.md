# Genome and transcriptome assembly for *Arabidopsis thaliana* accession N13
Data is from Lian, Q., Huettel, B., Walkemeier, B. et al. A pan-genome of 69 Arabidopsis thaliana accessions reveals a conserved genome structure throughout the global species range. Nat Genet 56, 982–991 (2024). https://doi.org/10.1038/s41588-024-01715-9

This analysis provides scripts for assembly from PacBio HiFi reads using three assembly methods: Flye, Hifiasm, and LJA, as well as transcriptome assembly from Illumina reads using Trinity. Assembly quality was assessed and cross-compared using FastQC, Jellyfish, BUSCO, QUAST, Merqury, nucmer, and mummerplot.

# Workflow
- 01-fastqc.sh - quality control of reads
- 02-kmer_counting.sh - kmer counting using Jellyfish
- 03a-flye.sh - genome assembly with Flye
- 03b-hifiasm.sh - genome assembly with Hifiasm
- 03c-lja.sh - genome assembly with LJA
- 03d-trinity.sh - transcriptome assembly with Trinity
- 04-busco.sh - assembly quality control with BUSCO
- 05a-quast.sh - assembly quality control with QUAST, using the TAIR10 reference genome
- 05a-quast-noref.sh - assembly quality control with QUAST, without any reference genomee
- 07a-nucmer.sh - alignment comparison between the three assemblies
- 07b-mummerplot.sh - dotplot visualization of alignment comparison between assemblies
- 08-merqury.sh - assembly quality control with merqury
