#!/bin/bash
#SBATCH --job-name=hifiasm_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch
 
set -euo pipefail
 
CONTAINER=/containers/apptainer/hifiasm_0.25.0.sif
WORKDIR=/data/users/slin/assembly_annotation_course
READS_DIR=$WORKDIR/N13
OUTDIR=$WORKDIR/hifiasm
PREFIX=N13
THREADS=${SLURM_CPUS_PER_TASK:-16}
 
mkdir -p "$OUTDIR"

READS=("$READS_DIR"/*.fastq.gz "$READS_DIR"/*.fq.gz "$READS_DIR"/*.fastq "$READS_DIR"/*.fq)
 
cd "$OUTDIR"
 
echo "Start: $(date)"
echo "Reads: ${READS[*]}"
 
apptainer exec --bind /data "$CONTAINER" hifiasm -o "$OUTDIR/$PREFIX" -t "$THREADS" "${READS[@]}"
 
for GFA in "$OUTDIR"/*.p_ctg.gfa; do
    awk '/^S/{print ">"$2;print $3}' "$GFA" > "${GFA%.gfa}.fa"
    echo "Converted: ${GFA%.gfa}.fa"
done
 
echo "Finished: $(date)"
 