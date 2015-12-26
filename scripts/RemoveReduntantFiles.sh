#!/bin/bash

# will go through all finished analysis and execute the RemoveReduntantFiles.sh script

MIP_DIR=$1

OLDPWD=$(pwd)
cd ${MIP_DIR}
for ANALYSIS in exomes genomes; do
    FINISHED=$(grep 'AnalysisRunStatus: Finished' -l */*/${ANALYSIS}/*/*_qc_sampleInfo.yaml)
    
    for RUN in ${FINISHED}; do
        ls -l ${RUN}
    
        CUST=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $1 }')
        FAMILY=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $2 }')
    
        echo "bash ${CUST}/${FAMILY}/${ANALYSIS}_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh"
        bash ${CUST}/${FAMILY}/${ANALYSIS}_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh
    done
done
cd ${OLDPWD}
