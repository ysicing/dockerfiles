FROM spanda/ptcore

LABEL maintainer="ysicing"

ADD nginx.tar.gz /usr/local/

COPY nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 80 443

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
