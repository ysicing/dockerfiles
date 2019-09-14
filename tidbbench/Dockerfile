FROM centos:centos7

MAINTAINER YsiCing Zheng <root@ysicing.net>

ENV REPO_URL="https://github.com/pingcap/tidb-bench.git"

RUN yum makecache;yum install -y wget; \
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo; \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo; \
    yum makecache;yum install -y sysbench ipef3 mysql curl git net-tools openssh-server openssh-clients; \
    yum clean all; \
    git clone --depth 1 ${REPO_URL} /root/tidbbench

EXPOSE  22

CMD ["/usr/sbin/sshd", "-D"]