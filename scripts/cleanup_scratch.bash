#!/bin/bash

VERSION=0.2.1
echo ${VERSION}

# get all job names
JOBNAMES=( `squeue --noheader --format=%i` )

# create batch script
BATCHSCRIPT=rm_scratch.bash

# submit a batch to each node, deleting all but jobnames dirs in scratch
NOW=$(date +"%Y%m%d%H%M%S")
for i in `seq 1 22`; do
    NODENAME=compute-0-$i;
    echo sbatch -c 1 -A prod001 --nodelist="$NODENAME" --output=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.$NOW.log --error=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.$NOW.err $BATCHSCRIPT ${JOBNAMES[*]}
    sbatch -c 1 -A prod001 --nodelist="$NODENAME" --output=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.$NOW.log --error=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.$NOW.err $BATCHSCRIPT ${JOBNAMES[*]}
done
