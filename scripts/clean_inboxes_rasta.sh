#!/bin/sh

BASEDIR=${1-'/mnt/hds/proj'} # where are the customer folders

PWD=$(pwd)

for CUSTDIR in ${BASEDIR}/cust*; do
    CUST=$(basename ${CUSTDIR})
    if [[ ${CUST} == 'cust000' ]]; then continue; fi

    if cd ${CUSTDIR}/INBOX/; then
        echo "=== $CUST"
        find . -maxdepth 1 ! -path . -mtime +100 -exec rm -rf {} \;
        cd ${BASEDIR}
    fi
done

cd ${PWD}
