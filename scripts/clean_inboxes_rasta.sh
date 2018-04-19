#!/bin/sh

BASEDIR=${1-'/mnt/hds/proj'} # where are the customer folders
DAYS=${2-'+100'}

PWD=$(pwd)

for CUSTDIR in ${BASEDIR}/cust*; do
    CUST=$(basename ${CUSTDIR})
    if [[ ${CUST} == 'cust000' ]]; then continue; fi

    if cd ${CUSTDIR}/INBOX/; then
        echo "=== $CUST"
        find . -maxdepth 1 ! -path . -mtime ${DAYS} -exec rm -rf {} \;
        cd ${BASEDIR}
    fi
done

cd ${PWD}
