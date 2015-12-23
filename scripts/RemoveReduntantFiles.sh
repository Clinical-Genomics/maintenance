#!/bin/bash

# will go through all finished analysis and execute the RemoveReduntantFiles.sh script

FINISHED=$(grep 'AnalysisRunStatus: Finished' -l */*/genomes/*/*_qc_sampleInfo.yaml)

for RUN in ${FINISHED}; do
    ls -l ${RUN}

    CUST=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $1 }')
    FAMILY=$(echo ${RUN} | awk 'BEGIN { FS="/" } { print $2 }')

    echo "bash ${CUST}/${FAMILY}/genomes_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh"
    bash ${CUST}/${FAMILY}/genomes_scripts/${FAMILY}/bwa/RemoveRedundantFiles_${FAMILY}.*.sh
done
