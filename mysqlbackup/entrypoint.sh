#!/bin/bash

if [ "$1" == "bash" ];then
    exec /bin/bash
fi

# installing mysql credentials if file does not exist
mysql_config="/root/.my.cnf"
if [ ! -f "$mysql_config" ]; then
    echo '[xtrabackup]' > /root/.my.cnf
    echo "user=$MYSQL_USER" >> /root/.my.cnf
    echo "password=$MYSQL_PASS" >> /root/.my.cnf
    echo "host=$MYSQL_HOST" >> /root/.my.cnf
    echo "port=$MYSQL_PORT" >> /root/.my.cnf
fi
if [ "$ENABLE" = "true" ];then
    if [ "$BACKUPTYPE" = "INCENABLE" ];then
        # incremental
        exec go-cron -s "${SCHEDULE:-@every 120s}" -- /bin/bash -c "/bin/backup incremental"
    elif [ "$BACKUPTYPE" = "FULL" ];then
        # full
        exec go-cron -s "${SCHEDULE:-@every 120s}" -- /bin/bash -c "/bin/backup full"
    elif [ "$BACKUPTYPE" = "ALL" ];then
        # all
        exec go-cron -s "${SCHEDULE:-@every 360s}" -- /bin/bash -c "echo '' "
    else
        # null
        exec go-cron -s "${SCHEDULE:-@every 360s}" -- /bin/bash -c "echo '' "
    fi
else
    # 未启用备份
    exec go-cron -s "${SCHEDULE:-@every 360s}" -- /bin/bash -c "echo '' "
fi