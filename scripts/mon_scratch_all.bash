#!/bin/bash

SCRATCH_LOG=/mnt/hds/proj/bioinfo/LOG/%s_scratch.log
TMP_LOG=/mnt/hds/proj/bioinfo/LOG/%s_tmp.log

for i in `seq 1 22`; do
    NODENAME=compute-0-$i;
    NODE_JOBS=$(squeue --noheader --format="%N %i" | grep $NODENAME | cut -d\  -f2- | tr '\n' ' ')

    SCRATCH_LOG_FILE=$( printf $SCRATCH_LOG $NODENAME )
    
    SCRATCH_DF=$(ssh $NODENAME df)
    if [[ $? -eq 0 ]]; then
        SCRATCH_DF=$(echo "$SCRATCH_DF" | grep scratch | awk '{print strftime("[%Y-%m-%d %H:%M:%S]"), $2" "$4}')
        printf "$SCRATCH_DF $NODE_JOBS\n" >> $SCRATCH_LOG_FILE
    fi

    TMP_LOG_FILE=$( printf $TMP_LOG $NODENAME )
    TMP_DF=$(ssh $NODENAME df)
    if [[ $? == 0 ]]; then
        TMP_DF=$(echo "$TMP_DF" | grep /dev/md2 | awk '{print strftime("[%Y-%m-%d %H:%M:%S]"), $2" "$4}')
        printf "$TMP_DF $NODE_JOBS\n" >> $TMP_LOG_FILE
    fi
done

