#!/bin/bash

# get all job names
JOBNAMES=( `squeue --noheader --format=%i` )

# create batch script
BATCHSCRIPT=rmscratch.bash

# submit a batch to each node, deleting all but jobnames dirs in scratch
for i in `seq 1 22`; do
    NODENAME=compute-0-$i;
    sudo -u hiseq.clinical sbatch -c 1 -A prod001 --nodelist="$NODENAME" --output=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.log --error=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.err $BATCHSCRIPT ${JOBNAMES[*]}
    echo sudo -u hiseq.clinical sbatch -c 1 -A prod001 --nodelist="$NODENAME" --output=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.log --error=/mnt/hds/proj/bioinfo/LOG/scratch-$NODENAME.err $BATCHSCRIPT ${JOBNAMES[*]}
done
