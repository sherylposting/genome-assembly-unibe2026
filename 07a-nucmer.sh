#!/bin/bash
#SBATCH --job-name=nucmer
#SBATCH --output=/data/users/slin/assembly_annotation_course/logs/nucmer_%j.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/logs/nucmer_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pshort_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail

CONTAINER=/containers/apptainer/mummer4_gnuplot.sif
WORKDIR=/data/users/slin/assembly_annotation_course
REF_DIR=/data/courses/assembly-annotation-course/references
OUTDIR="$WORKDIR/mummer"

REF="$REF_DIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

FLYE="$WORKDIR/flye/assembly.fasta"
HIFIASM="$WORKDIR/hifiasm/N13.bp.p_ctg.fa"
LJA="$WORKDIR/lja/assembly.fasta"

mkdir -p "$OUTDIR"

echo "Start: $(date)"

# Reference vs assemblies
apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/ref_vs_flye" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$REF" "$FLYE"

apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/ref_vs_hifiasm" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$REF" "$HIFIASM"

apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/ref_vs_lja" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$REF" "$LJA"

# Assembly vs assembly
apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/flye_vs_hifiasm" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$FLYE" "$HIFIASM"

apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/flye_vs_lja" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$FLYE" "$LJA"

apptainer exec --bind /data "$CONTAINER" nucmer \
    --prefix "$OUTDIR/hifiasm_vs_lja" \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads "$SLURM_CPUS_PER_TASK" \
    "$HIFIASM" "$LJA"

echo "Finished: $(date)"
ls -lh "$OUTDIR"
