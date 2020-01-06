#!/bin/bash
fullPath="/data/backup/full"
incrPath="/data/backup/incremental"
bakdate=`date +'%F'`
bakhour=`date +'%H'`
#oneHourAgo=`date -d '1 hours ago' +'%F_%H'`
BakBin="/usr/bin/xtrabackup \
--datadir=/data/data \
--backup \
--use-memory=${memory:-1G} \
--throttle=${throttle:-10}"

[ -d "$fullPath" ] || mkdir -p "$fullPath"
[ -d "$incrPath" ] || mkdir -p "$incrPath"

# backup function
function hotbackup(){
  baktype=$1
  logfile=$2
  incrpath=$3
  bakpath=$4
  if [ "$baktype" == "full" ];then
    $BakBin --target-dir=$bakpath > $logfile 2>&1
  elif [ "$baktype" == "incremental" ];then
    echo "$BakBin --target-dir=$incrpath --incremental-basedir $bakpath > $logfile 2>&1"
  fi
}

# backup status
function status(){
  if [ "$1" == 0 ];then
      status_info="$(date +%F\ %H:%M) Backup completed."
  else
      status_info="$(date +%F\ %H:%M) Backup not completed"
  fi
  if [ ! -z $DINGTOKEN ];then
    curl 'https://oapi.dingtalk.com/robot/send?access_token='$DINGTOKEN''  -H 'Content-Type: application/json' -d '{"msgtype": "text","text": {"content": "'"$status_info"'"}}'
    echo "$status_info -- $DINGTOKEN"
  else
    echo "$status_info"
  fi
}

# type ftp / minio
function upload(){
    echo "pass"
}

# ============= Main =============
if [ "$1" == "full" ];then
  hotbackup "full" "${fullPath}/${bakdate}.log" "none" "$fullPath/$bakdate"
  backup_status=$?
  status $backup_status >> ${fullPath}/dd.log
  if [ "$backup_status" -eq 0 ];then
    tar zcvf  $fullPath/full_$bakdate.tgz "$fullPath/$bakdate"
    # upload >> ${fullPath}/backup.log
  fi
elif [ "$1" == "incremental" ];then
  if [ "$2" == "first" ];then
    hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$fullPath/$bakdate"
  else
    hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$incrPath/${oneHourAgo}"
  fi
fi