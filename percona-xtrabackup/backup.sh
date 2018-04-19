#!/bin/bash
fullPath="/data/backup/full"
incrPath="/data/backup/incremental"
bakdate=`date +'%F'`
bakhour=`date +'%H'`
oneHourAgo=`date -d '1 hours ago' +'%F_%H'`
BakBin="/usr/bin/xtrabackup --no-defaults \
--datadir=/data/data \
--backup \
--throttle=1

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
    #echo "$BakBin --target-dir=$bakpath > $logfile 2>&1"
  elif [ "$baktype" == "incremental" ];then
#    $BakBin --target-dir=$incrpath --incremental-basedir $bakpath > $logfile 2>&1
    echo "$BakBin --target-dir=$incrpath --incremental-basedir $bakpath > $logfile 2>&1"
  fi
}
# ============= Main =============
if [ "$1" == "full" ];then
   # 全量备份
   hotbackup "full" "${fullPath}/${bakdate}.log" "none" "$fullPath/$bakdate"
elif [ "$1" == "incremental" ];then
  # 判断是否为第一次增量备份，只有第一次增量备份目录指向全量备份
  # 第二次开始增量备份的上一次目录指向第一次增量目录即可
  if [ "$2" == "first" ];then
     hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$fullPath/$bakdate"
  else
     hotbackup "incremental" "${incrPath}/${bakdate}_${bakhour}.log" "$incrPath/${bakdate}_${bakhour}" "$incrPath/${oneHourAgo}"
  fi
fi