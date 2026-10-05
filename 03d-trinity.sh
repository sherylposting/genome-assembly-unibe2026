#!/bin/bash
#SBATCH --job-name=trinity_assembly
#SBATCH --time=1-00:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --partition=pibu_el8
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sheryl.lin@students.unibe.ch

set -euo pipefail
 
WORKDIR=/data/users/slin/assembly_annotation_course
READS_DIR=$WORKDIR/RNAseq_Sha
OUTDIR=$WORKDIR/trinity
THREADS=${SLURM_CPUS_PER_TASK:-16}

mkdir -p "$OUTDIR"

module purge
module load Trinity/2.15.1-foss-2021a
 
LEFT=("$READS_DIR"/*_1.fastq.gz "$READS_DIR"/*_1.fq.gz "$READS_DIR"/*_R1*.fastq.gz "$READS_DIR"/*_R1*.fq.gz)
RIGHT=("$READS_DIR"/*_2.fastq.gz "$READS_DIR"/*_2.fq.gz "$READS_DIR"/*_R2*.fastq.gz "$READS_DIR"/*_R2*.fq.gz)
 
LEFT_LIST=$(IFS=,; echo "${LEFT[*]}")
RIGHT_LIST=$(IFS=,; echo "${RIGHT[*]}")
 
echo "Start: $(date)"
echo "Left:  $LEFT_LIST"
echo "Right: $RIGHT_LIST"
 
Trinity --seqType fq \
    --left "$LEFT_LIST" \
    --right "$RIGHT_LIST" \
    --CPU "$THREADS" \
    --max_memory 60G \
    --output "$OUTDIR"
 
echo "Finished: $(date)"