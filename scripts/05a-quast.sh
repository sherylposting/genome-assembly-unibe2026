#!/bin/bash
#SBATCH --job-name=Quast_ref
#SBATCH --output=/data/users/slin/assembly_annotation_course/logs/quast_ef_%j.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/logs/quast_ref_%j.err
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --partition=pibu_el8
#SBATCH --array=0-0
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail
 
CONTAINER=/containers/apptainer/quast_5.2.0.sif
WORKDIR=/data/users/slin/assembly_annotation_course
REF_DIR=/data/courses/assembly-annotation-course/references
OUTDIR=$WORKDIR/quast/with_reference
THREADS=${SLURM_CPUS_PER_TASK:-16}

mkdir -p "$OUTDIR"
 
ASSEMBLIES=(
    "$WORKDIR/flye/assembly.fasta"
    "$WORKDIR/hifiasm/N13.bp.p_ctg.fa"
    "$WORKDIR/lja/assembly.fasta"
)
LABELS="flye,hifiasm,lja"
 
REF="$REF_DIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
GFF="$REF_DIR/Arabidopsis_thaliana.TAIR10.57.gff3"
 
echo "Start: $(date)"
echo "Reference:  $REF"
echo "Annotation: $GFF"
 
apptainer exec --bind /data "$CONTAINER" quast.py \
    "${ASSEMBLIES[@]}" \
    --labels "$LABELS" \
    -r "${REF[0]}" \
    --features "${GFF[0]}" \
    --eukaryote \
    --threads "$THREADS" \
    -o "$OUTDIR"
 
echo "Finished: $(date)"
cat "$OUTDIR/report.txt"