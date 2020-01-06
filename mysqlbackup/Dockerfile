FROM ysicing/plugins:base-mysql

ADD entrypoint.sh /bin/entrypoint
ADD backup.sh /bin/backup

RUN chmod 755 /bin/entrypoint /bin/backup

ENTRYPOINT ["entrypoint"]