#!/bin/bash

# checks if a run still syncs
set -ue

EMAIL=clinical-demux@scilifelab.se

#############
# FUNCTIONS #
#############
 
log() {
    NOW=$(date +"%Y%m%d%H%M%S")

    echo [${NOW}] $@
}

errr() {
    echo "$(hostname): err while running $0" | mail -s "$(hostname): err while running $0" ${EMAIL}
}
trap errr ERR

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
        LAST_TIMESTAMP=$(find ${RUN}/Data/Intensities/BaseCalls/L001/ -type d -printf '%T@\n' | sort -n | tail -1)
        if [[ -z ${LAST_TIMESTAMP} ]]; then
            LAST_TIMESTAMP=$(find ${RUN} -type f -printf '%T@\n' | sort -n | tail -1) 
        fi
        LAST_TIMESTAMP_AGO=$(( $(date +%s) - ${LAST_TIMESTAMP%%.*} ))

        # if latest file older then 2h45mins ...
        # between reading index and read2 there are 2h30mins of no data!
        if [[ $LAST_TIMESTAMP_AGO -gt 10000 ]]; then
            MSG="$(hostname):${RUN} is not syncing anymore!"
            echo "${MSG}" | mail -s "${MSG}" ${EMAIL}
            log "${RUN} Sync FAIL!"
        else
            log "${RUN} Syncing"
        fi
    else
        log "${RUN} Finished"
    fi
done
