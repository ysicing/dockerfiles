FROM ysicing/debian AS fetch

RUN wget https://github.com/zhboner/realm/releases/download/v2.7.0/realm-x86_64-unknown-linux-gnu.tar.gz && \
    tar -zxvf realm-x86_64-unknown-linux-gnu.tar.gz && \
    mv realm /usr/bin/realm && \
    chmod +x /usr/bin/realm && \
    rm -rf realm-x86_64-unknown-linux-gnu.tar.gz

FROM ysicing/debian

WORKDIR /app

COPY --from=fetch /usr/bin/realm /usr/bin/r3m

COPY r3m.toml /app/r3m.toml

CMD [ "/usr/bin/r3m", "-c", "/app/r3m.toml" ]
