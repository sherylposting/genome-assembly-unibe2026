#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=2:00:00
#SBATCH --job-name=merqury
#SBATCH --mail-user=sheryl.lin@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/slin/assembly_annotation_course/logs/output_merqury_%j.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/logs/error_merqury_%j.err
#SBATCH --partition=pshort_el8

WORKDIR=/data/users/slin/assembly_annotation_course
OUTDIR=$WORKDIR/merqury

mkdir -p $OUTDIR
cd $OUTDIR

export MERQURY="/usr/local/share/merqury"

# Build meryl k-mer database from HiFi reads (k=18, best k-mer size for A. thaliana found with best_k.sh)
apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
meryl k=18 count \
$WORKDIR/N13/ERR11437334.fastq.gz \
output $OUTDIR/reads.meryl

# Run merqury on each assembly

apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
merqury.sh $OUTDIR/reads.meryl \
$WORKDIR/flye/assembly.fasta \
flye_merqury

apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
merqury.sh $OUTDIR/reads.meryl \
$WORKDIR/hifiasm/N13.p_ctg.fa \
hifiasm_merqury

apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
merqury.sh $OUTDIR/reads.meryl \
$WORKDIR/lja/assembly.fasta \
lja_merqury