#!/bin/bash
#SBATCH --job-name=lja_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail
 
CONTAINER=/containers/apptainer/lja-0.2.sif
WORKDIR=/data/users/slin/assembly_annotation_course
READS_DIR=$WORKDIR/N13
OUTDIR=$WORKDIR/lja
THREADS=${SLURM_CPUS_PER_TASK:-16}

mkdir -p "$OUTDIR"
 
READS=("$READS_DIR"/*.fastq.gz "$READS_DIR"/*.fq.gz "$READS_DIR"/*.fastq "$READS_DIR"/*.fq)
 
READ_ARGS=()
for R in "${READS[@]}"; do
    READ_ARGS+=(--reads "$R")
done
 
echo "Start: $(date)"
echo "Reads: ${READS[*]}"
 
apptainer exec --bind /data "$CONTAINER" lja -o "$OUTDIR" -t "$THREADS" "${READ_ARGS[@]}"
 
echo "Finished: $(date)"
echo "Assembly: $OUTDIR/assembly.fasta"