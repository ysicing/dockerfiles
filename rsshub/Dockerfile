FROM node:slim

MAINTAINER ysicing

RUN apt-get update && apt-get install -yqq --no-install-recommends curl git ca-certificates && \
    git clone https://github.com/DIYgod/RSSHub.git /app && \
    cd /app && \
    npm install && \
    rm -rf /var/lib/apt/lists/* 

WORKDIR /app

CMD [ "node","index.js" ]