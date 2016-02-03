#!/bin/bash

NASES=(clinical-nas-2 seq-nas-1 seq-nas-2 seq-nas-3 nas-6 nas-7 nas-8 nas-9 nas-10)
SCRIPT_DIR=$(dirname $0)

for NAS in ${NASES[@]}; do
    echo -n ${NAS}
    ssh ${NAS} ps -ef | grep lsync | grep -q hiseq.bioinfo
    if [[ $? -eq 0 ]]; then
        echo ' OK!'
    else
        echo ' FAIL!'
        echo "Lsync process stopped in ${NAS}" | mail -s "LSYNC is not running anymore" kenny.billiau@scilifelab.se
    fi
done
