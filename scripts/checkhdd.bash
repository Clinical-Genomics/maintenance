#!/bin/bash
#
#    Usage: overview.bash
#      run as hiseq.clinical 
#      use screen or nohup
#
. /home/clinical/CONFIG/configuration.txt
echo "Variables read in from /home/clinical/CONFIG/configuration.txt"
echo "              RUNBASE  -  ${RUNBASE}"
echo "            BACKUPDIR  -  ${BACKUPDIR}"
echo "           OLDRUNBASE  -  ${OLDRUNBASE}"
echo "              PREPROC  -  ${PREPROC}"
echo "       PREPROCRUNBASE  -  ${PREPROCRUNBASE}"
echo "         BACKUPSERVER  -  ${BACKUPSERVER}"
echo "BACKUPSERVERBACKUPDIR  -  ${BACKUPSERVERBACKUPDIR}"
echo "         BACKUPCOPIED  -  ${BACKUPCOPIED}"
echo "               LOGDIR  -  ${LOGDIR}"
for server in ${servers[@]}; do
  echo "               server  -  ${server}"
done
NOW=$(date +"%Y%m%d%H%M%S")


for server in ${servers[@]}; do
  NOW=$(date +"%Y%m%d%H%M%S")
  echo
  echo "[${NOW}] Will check ${server} [from clinical-db]"
  dirhome=$(ssh ${server} df -h /home | grep "/home" | awk '{print $NF,$(NF-1)}')
  value="$(echo ${dirhome} | awk '{split($2,arr,"%");print arr[1]}')"
  if [[ ${value} -ge 89 ]]; then
    WARNING="   -  C R I T I C A L !"
  fi
  echo "     home ${server}     [ Use%=${value} ${WARNING} ]"
  WARNING=""
done

echo
echo "[${NOW}] Will check rastapopoulos [cluster]"
rastahds=$(ssh rastapopoulos.scilifelab.se df -h | grep "/mnt/hds$" | awk '{print $NF,$(NF-1)}' | awk '{split($2,arr,"%");print arr[1]}')
NOW=$(date +"%Y%m%d%H%M%S")
WARNING=""
if [[ "${rastahds}" -ge 89 ]]; then
  WARNING="   -  C R I T I C A L !"
fi
echo " rastapopoulos  hds    [ Use%=${rastahds} ${WARNING} ]"
echo


exit 0

