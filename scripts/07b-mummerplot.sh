#!/bin/bash
#SBATCH --job-name=mummerplot
#SBATCH --output=/data/users/slin/assembly_annotation_course/logs/mummerplot_%j.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/logs/mummerplot_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=2
#SBATCH --partition=pshort_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail

CONTAINER=/containers/apptainer/mummer4_gnuplot.sif
WORKDIR=/data/users/slin/assembly_annotation_course
OUTDIR="$WORKDIR/mummer"

REF="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
FLYE="$WORKDIR/flye/assembly.fasta"
LJA="$WORKDIR/lja/assembly.fasta"
HIFIASM="$WORKDIR/hifiasm/N13.bp.p_ctg.fa"

echo "Start: $(date)"

# Reference vs Flye
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$REF" \
    -Q "$FLYE" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/ref_vs_flye" \
    "$OUTDIR/ref_vs_flye.delta"

# Reference vs Hifiasm
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$REF" \
    -Q "$HIFIASM" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/ref_vs_hifiasm" \
    "$OUTDIR/ref_vs_hifiasm.delta"

# Reference vs LJA
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$REF" \
    -Q "$LJA" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/ref_vs_lja" \
    "$OUTDIR/ref_vs_lja.delta"

# Flye vs Hifiasm
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$FLYE" \
    -Q "$HIFIASM" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/flye_vs_hifiasm" \
    "$OUTDIR/flye_vs_hifiasm.delta"

# Flye vs LJA
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$FLYE" \
    -Q "$LJA" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/flye_vs_lja" \
    "$OUTDIR/flye_vs_lja.delta"

# Hifiasm vs LJA
apptainer exec --bind /data "$CONTAINER" mummerplot \
    -R "$HIFIASM" \
    -Q "$LJA" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    -p "$OUTDIR/hifiasm_vs_lja" \
    "$OUTDIR/hifiasm_vs_lja.delta"

echo "Finished: $(date)"
