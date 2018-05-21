FROM atlassian/confluence-server

COPY hack/*.jar ${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/lib/

RUN chown -R ${RUN_USER}:${RUN_GROUP} ${CONFLUENCE_INSTALL_DIR}/confluence/WEB-INF/lib/atlassian-extras-decoder-v2-3.2.jar

CMD ["/entrypoint.sh", "-fg"]
ENTRYPOINT ["/sbin/tini", "--"]