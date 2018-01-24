#!/bin/bash

# checks if a run still syncs
set -ue

RUN_DIR=${1?'please provide base run dir'}
TIMEOUT=${2-10000}
EMAIL=${3-clinical-demux@scilifelab.se}
# Default timeout is set to 2h30m (10000) as this is the time
# between reading index and read2 for an X-run where there is no data.

#############
# FUNCTIONS #
#############
 
log() {
    NOW=$(date +"%Y%m%d%H%M%S")

    echo [${NOW}] $@
}

errr() {
    echo "$(hostname): err while running $(caller)" | mail -s "$(hostname): err while running $0" ${EMAIL}
}
trap errr ERR

########
# MAIN #
########

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

        if [[ ${LAST_TIMESTAMP_AGO} -gt ${TIMEOUT} ]]; then
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
