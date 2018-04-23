#!/bin/bash
fullPath="/data/backup/full"
incrPath="/data/backup/incremental"
bakdate=`date +'%F-%H-%M'`
bakhour=`date +'%H'`
oneHourAgo=`date -d '1 hours ago' +'%F_%H'`
BakBin="/usr/bin/xtrabackup \
--datadir=/data/data \
--backup \
--throttle=1"

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
    status_info="Full Backup complete"
    curl 'https://oapi.dingtalk.com/robot/send?access_token='$DINGTOKEN''  -H 'Content-Type: application/json' -d '{"msgtype": "text","text": {"content": "Full Backup complete"}}'
  else
    status_info="Full Backup not complete"
    curl 'https://oapi.dingtalk.com/robot/send?access_token='$DINGTOKEN''  -H 'Content-Type: application/json' -d '{"msgtype": "text","text": {"content": "Full Backup not complete"}}'
  fi
  echo "$status_info -- $DINGTOKEN"
}

# ============= Main =============
if [ "$1" == "full" ];then
   hotbackup "full" "${fullPath}/${bakdate}.log" "none" "$fullPath/$bakdate"
   status $? >> ${fullPath}/dd.log
elif [ "$1" == "incremental" ];then
  if [ "$2" == "first" ];then
     hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$fullPath/$bakdate"
  else
     hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$incrPath/${oneHourAgo}"
  fi
fi
