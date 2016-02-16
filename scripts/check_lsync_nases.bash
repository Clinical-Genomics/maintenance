#!/bin/bash


##########
# PARAMS #
##########

NASES=(clinical-nas-2 seq-nas-1 seq-nas-2 seq-nas-3 nas-6 nas-7 nas-8 nas-9 nas-10)
EMAILS=kenny.billiau@scilifelab.se,emma.sernstad@scilifelab.se,robin.andeer@scilifelab.se,daniel.backman@scilifelab.se

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
    # get the process list on the NAS
    SSH_PS=$(ssh ${NAS} ps -ef)

    # check if that command succeeded
    if [[ $? -ne 0 ]]; then
        # ssh fail, network fail ... try again in next iteration
    	log "${NAS} Network FAIL!"
        echo "${NAS} was not reachable" | mail -s "${NAS} was not reachable!" ${EMAILS}
        continue
    fi

    # check the process list on the NAS
    echo "$SSH_PS" | grep lsync | grep -q hiseq.bioinfo
    if [[ $? -eq 0 ]]; then
    	log "${NAS} OK!"
    else
    	log "${NAS} FAIL!"
        echo "Lsync process stopped in ${NAS}" | mail -s "LSYNC is not running anymore" ${EMAILS}
    fi
    sleep 2
done
