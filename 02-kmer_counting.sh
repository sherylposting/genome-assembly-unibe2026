#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=70G
#SBATCH --time=02:00:00
#SBATCH --job-name=jellyfish_kmer
#SBATCH --mail-user=sheryl.lin@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/slin/assembly_annotation_course/QC/logs/output_jellyfish_%j.o
#SBATCH --error=/data/users/slin/assembly_annotation_course/QC/logs/error_jellyfish_%j.e
#SBATCH --partition=pshort_el8

WORKDIR=/data/users/slin/assembly_annotation_course
INPUT_DIR="/data/users/slin/assembly_annotation_course/N13"
OUTPUT_DIR=$WORKDIR/jellyfish

mkdir -p $OUTPUT_DIR

apptainer exec \
    --bind /data \
    /containers/apptainer/jellyfish-2.2.6--0.sif \
    jellyfish count \
    -C \
    -m 31 \
    -s 5G \
    -t 4 \
    <(zcat $INPUT_DIR/ERR11437334.fastq.gz) \
    -o $OUTPUT_DIR/reads.jf

apptainer exec \
    --bind /data \
    /containers/apptainer/jellyfish-2.2.6--0.sif \
    jellyfish histo \
    -t 4 \
    $OUTPUT_DIR/reads.jf > $OUTPUT_DIR/reads.histo