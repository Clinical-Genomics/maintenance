#!/bin/bash


##########
# PARAMS #
##########

NASES=(clinical-nas-2 seq-nas-1 seq-nas-2 seq-nas-3 nas-6 nas-7 nas-8 nas-9 nas-10)
SCRIPT_DIR=$(dirname $0)

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

for NAS in ${NASES[@]}; do
    ssh ${NAS} ps -ef | grep lsync | grep -q hiseq.bioinfo
    if [[ $? -eq 0 ]]; then
    	log "${NAS} OK!"
    else
    	log "${NAS} FAIL!"
        echo "Lsync process stopped in ${NAS}" | mail -s "LSYNC is not running anymore" kenny.billiau@scilifelab.se,emma.sernstad@scilifelab.se,robin.andeer@scilifelab.se,daniel.backman@scilifelab.se
    fi
done
