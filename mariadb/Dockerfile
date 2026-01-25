# MariaDB with optimized configuration
# Based on official MariaDB image

ARG MARIADB_VERSION=12.1
FROM mariadb:${MARIADB_VERSION}

LABEL maintainer="ysicing <ysicing@12306.work>"

ENV TZ="Asia/Shanghai"

# Copy custom configuration
COPY conf.d/ /etc/mysql/conf.d/
