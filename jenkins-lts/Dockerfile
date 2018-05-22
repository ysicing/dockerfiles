FROM jenkins/jenkins:lts

USER root

RUN apt-get -qq update \
    && apt-get -qq -y install \
    curl \
    &&  rm -rf /var/lib/apt/lists/* 

RUN curl -sSL https://get.docker.com/ | sh

RUN usermod -a -G staff jenkins

USER jenkins