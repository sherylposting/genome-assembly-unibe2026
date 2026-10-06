#!/bin/bash
#SBATCH --job-name=Quast_noref
#SBATCH --output=/data/users/slin/assembly_annotation_course/logs/quast_noref_%j.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/logs/quast_noref_%j.err
#SBATCH --time=2:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pshort_el8
#SBATCH --array=0-0
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail
 
CONTAINER=/containers/apptainer/quast_5.2.0.sif
WORKDIR=/data/users/slin/assembly_annotation_course
REF_DIR=/data/courses/assembly-annotation-course/references
OUTDIR=$WORKDIR/quast/no_reference
THREADS=${SLURM_CPUS_PER_TASK:-16}
EST_SIZE=135000000

mkdir -p "$OUTDIR"
 
ASSEMBLIES=(
    "$WORKDIR/flye/assembly.fasta"
    "$WORKDIR/hifiasm/N13.bp.p_ctg.fa"
    "$WORKDIR/lja/assembly.fasta"
)
LABELS="flye,hifiasm,lja"
 
echo "Start: $(date)"
 
apptainer exec --bind /data "$CONTAINER" quast.py \
    "${ASSEMBLIES[@]}" \
    --labels "$LABELS" \
    --eukaryote \
    --threads "$THREADS" \
    -o "$OUTDIR"
 
echo "Finished: $(date)"
cat "$OUTDIR/report.txt"