#!/bin/bash

# will go through all finished analysis and execute the RemoveReduntantFiles.sh script

##########
# PARAMS #
##########

MIP_DIR=$1
MAX_AGE=${2-7}

#############
# FUNCTIONS #
#############
 
logn() {
    NOW=$(date +"%Y%m%d%H%M%S")

    echo -n [${NOW}] $@
}

########
# MAIN #
########

OLDPWD=$(pwd)
cd ${MIP_DIR}
for ANALYSIS in exomes genomes; do
    FINISHED=$(grep 'AnalysisRunStatus: Finished' -l */*/${ANALYSIS}/*/*_qc_sampleInfo.yaml)
    
    for RUN in ${FINISHED}; do

       # only remove the runs that are a week old...
       DAYS_AGO=$(( ( $(date +%s) - $(stat ${RUN} -c %Y) ) / ( 60 * 60 * 24 ) ))
       logn "${RUN} ran ${DAYS_AGO} days ago"
       if [[ ${DAYS_AGO} -gt ${MAX_AGE} ]]; then
            CUST=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $1 }')
            FAMILY=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $2 }')
 
            #echo "bash ${CUST}/${FAMILY}/${ANALYSIS}_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh"
            bash ${CUST}/${FAMILY}/${ANALYSIS}_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh &> /dev/null
            if [[ $? -eq 0 ]]; then
                echo ", removing redundant files ..."
            else
                echo ", already removed!"
            fi
        else
            echo ", younger than ${MAX_AGE} days! Keeping."
        fi
    done
done
cd ${OLDPWD}
