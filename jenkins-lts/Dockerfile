FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y libltdl7 sudo \
    && rm -rf /var/lib/apt/lists/* \
    && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins