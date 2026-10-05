#!/bin/bash
#SBATCH --job-name=flye_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --output=logs/flye_%j.out
#SBATCH --error=logs/flye_%j.err
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail
 
CONTAINER=/containers/apptainer/flye_2.9.5.sif
WORKDIR=/data/users/slin/assembly_annotation_course
READS_DIR=$WORKDIR/N13
OUTDIR=$WORKDIR/flye
THREADS=${SLURM_CPUS_PER_TASK:-16}
 
READS=("$READS_DIR"/*.fastq.gz "$READS_DIR"/*.fq.gz "$READS_DIR"/*.fastq "$READS_DIR"/*.fq)
 
FLYE_ARGS=(--pacbio-hifi "${READS[@]}" --out-dir "$OUTDIR" --threads "$THREADS")
 
echo "Start: $(date)"
echo "Reads: ${READS[*]}"
 
apptainer exec --bind /data "$CONTAINER" flye "${FLYE_ARGS[@]}"
 
echo "Finished: $(date)"
