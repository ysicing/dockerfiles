# MySQL with optimized configuration and replication enabled
# Based on official MySQL image

ARG MYSQL_VERSION=9
FROM mysql:${MYSQL_VERSION}

LABEL maintainer="ysicing <ysicing@12306.work>"

ENV TZ="Asia/Shanghai"

# 慢查询日志目录，避免日志路径不存在导致启动失败
RUN mkdir -p /var/log/mysql && chown -R mysql:mysql /var/log/mysql

# Copy custom configuration
COPY conf.d/ /etc/mysql/conf.d/
