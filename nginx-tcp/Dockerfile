FROM spanda/ptcore

LABEL maintainer="ysicing"

ADD nginx.tar.gz /usr/local/

EXPOSE 80 443

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
