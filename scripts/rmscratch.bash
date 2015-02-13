#!/bin/bash

STARTDIR=/scratch

for d in `ls $STARTDIR`; do
    if [[ ${@#} > 0 ]]; then
        if [[ "${@} " =~ "$d " ]]; then
            continue
        fi
    fi
    echo chmod -R a+w "$STARTDIR/$d"
    chmod -R a+w "$STARTDIR/$d"
    echo rm -rf "$STARTDIR/$d"
    rm -rf "$STARTDIR/$d"
done
