#!/bin/bash

# checks if a run still syncs

RUN_DIR=$1
for RUN in ${RUN_DIR}/*; do
    # skip non-runs
    if [[ ! -d ${RUN} ]]; then continue; fi

    echo -n ${RUN}

    if [[ ! -f ${RUN}/RTAComplete.txt ]]; then
        # fine last file
        LAST_TIMESTAMP=$(find ${RUN} -type f -printf '%T@' | sort -n | tail -1) 
        LAST_TIMESTAMP_AGO=$(( $(date +%s) - ${LAST_TIMESTAMP##.*} ))

        # if latest file older then 15mins ...
        if [[ $LAST_TIMESTAMP_AGO -gt 1000 ]]; then
            #echo "${RUN} is not syncing anymore!" | mail -s "${RUN} is not running anymore!" kenny.billiau@scilifelab.se,emma.sernstad@scilifelab.se,robin.andeer@scilifelab.se,daniel.backman@scilifelab.se
            echo ' Sync FAIL!'
        else
            echo ' Syncing'
        fi
    else
        echo ' Finished'
    fi
done
