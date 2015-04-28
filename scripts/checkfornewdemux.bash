#!/bin/bash
#

source /mnt/hds/proj/bioinfo/SCRIPTS/log.bash
log $(getversion)

UNABASE=/mnt/hds/proj/bioinfo/DEMUX/
ALIBASE=/mnt/hds/proj/bioinfo/ALIGN/
runs=$(ls ${UNABASE})
for run in ${runs[@]}; do
  NOW=$(date +"%Y%m%d%H%M%S")
  if [ -f ${UNABASE}${run}/copycomplete.txt ]; then
    if [ -f ${UNABASE}${run}/delivery.txt ]; then
      echo [${NOW}] [${run}] copy is complete and delivery has already started 
    else
      echo [${NOW}] [${run}] copy is complete delivery has not started
      echo [${NOW}] [${run}] copy is complete delivery is started > ${UNABASE}${run}/delivery.txt 
      FC=$(echo ${run} | awk 'BEGIN {FS="/"} {split($(NF-1),arr,"_");print substr(arr[4],2,length(arr[4]))}')
  ## addition 20150428 auto QXT trimming
      if [ -f ${UNABASE}${run}/trimmed.txt ]; then
        echo [${NOW}] [${run}] trimming already finished
      else
      	/home/hiseq.clinical/miniconda/envs/prod/bin/python /mnt/hds/proj/bioinfo/SCRIPTS/trimqxt.py ${UNABASE}${run} 2>&1 > /mnt/hds/proj/bioinfo/LOG/trimQXT.${FC}.${NOW}.log
      fi
      if [ -f ${UNABASE}${run}/trimming.txt ]; then
        echo [${NOW}] [${run}] trimming is in progress
      else

  ## addition 20150219 testing auto summary and linking
        /home/hiseq.clinical/miniconda/envs/prod/bin/python /mnt/hds/proj/bioinfo/SCRIPTS/getsamplesummary.py ${FC} 2>&1 > /mnt/hds/proj/bioinfo/LOG/samplesum.${FC}.${NOW}.log
  ## a  ddition ends
        sbatch /mnt/hds/proj/bioinfo/SCRIPTS/getfastq.batch ${UNABASE}${run}
      fi
    fi
#    if [ -d ${ALIBASE}${run}/Aligned ]; then
#      echo [${NOW}] [${run}] copy is complete and alignment has already started 
#    else
#      echo [${NOW}] [${run}] copy is complete alignment has not started
#      sbatch /mnt/hds/proj/bioinfo/SCRIPTS/align.batch ${UNABASE}${run}
#    fi
  else
    echo [${NOW}] [${run}] is not yet completely copied
  fi
done

