#!/bin/bash

VERSION=2.3.11
LOG_DIR=${1-/mnt/hds/proj/bioinfo/LOG/}


NOW=$(date +"%Y%m%d%H%M%S")
echo "[$NOW] ${VERSION}"

# get all job names
JOBNAMES=( `squeue --noheader --format=%i` )

# create batch script
BATCHSCRIPT=/mnt/hds/proj/bioinfo/SCRIPTS/rm_scratch_node.batch

# submit a batch to each node, deleting all but jobnames dirs in scratch
for i in {1..22}; do
    NODENAME=compute-0-$i;
    echo sbatch -c 1 -A prod001 --nodelist="$NODENAME" --output=${LOG_DIR}/scratch-$NODENAME.$NOW.log --error=${LOG_DIR}/scratch-$NODENAME.$NOW.err $BATCHSCRIPT ${JOBNAMES[*]}
    sbatch -c 1 -A prod001 -t '00:15:00' --nodelist="$NODENAME" --output=${LOG_DIR}/scratch-$NODENAME.$NOW.log --error=${LOG_DIR}/scratch-$NODENAME.$NOW.err $BATCHSCRIPT ${JOBNAMES[*]}
done
