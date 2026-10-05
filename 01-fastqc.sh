#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/slin/assembly_annotation_course/output_dir/fastqc_out/fastqc_%A_%a.out
#SBATCH --error=/data/users/slin/assembly_annotation_course/output_dir/error_out/fastqc_%A_%a.err
#SBATCH --time=02:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --partition=pshort_el8

# Set paths
CONTAINER="/containers/apptainer/fastqc-0.12.1.sif"
INPUT_DIR="/data/users/slin/assembly_annotation_course/N13"
OUTPUT_DIR="/data/users/slin/assembly_annotation_course"

# Run FastQC using Apptainer container
apptainer exec --bind /data:/data "$CONTAINER" fastqc \
    "$INPUT_DIR"/ERR11437334.fastq.gz \
    -o "$OUTPUT_DIR" \
    -t $SLURM_CPUS_PER_TASK
    
