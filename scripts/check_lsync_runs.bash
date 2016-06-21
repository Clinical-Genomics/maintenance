#!/bin/bash

# checks if a run still syncs

#############
# FUNCTIONS #
#############
 
log() {
    NOW=$(date +"%Y%m%d%H%M%S")

    echo [${NOW}] $@
}

########
# MAIN #
########

RUN_DIR=$1
for RUN in ${RUN_DIR}/*; do
    # skip non-runs
    if [[ ! -d ${RUN} ]]; then continue; fi

    # if the run is not complete, check if it is still syncing!
    if [[ ! -f ${RUN}/RTAComplete.txt ]]; then
        # creation timestamp last file
        LAST_TIMESTAMP=$(find ${RUN}/Logs -type f -printf '%T@\n' | sort -n | tail -1) 
        LAST_TIMESTAMP_AGO=$(( $(date +%s) - ${LAST_TIMESTAMP%%.*} ))

        # if latest file older then 2h45mins ...
        # between reading index and read2 there are 2h30mins of no data!
        if [[ $LAST_TIMESTAMP_AGO -gt 10000 ]]; then
            echo "${RUN} is not syncing anymore!" | mail -s "${RUN} is not running anymore!" bioinfo.clinical@scilifelab.se
            log "${RUN} Sync FAIL!"
        else
            log "${RUN} Syncing"
        fi
    else
        log "${RUN} Finished"
    fi
done
