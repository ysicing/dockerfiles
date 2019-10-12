FROM ysicing/alpine:latest AS builder

LABEL maintainer="ysicing <i@ysicing.me>"

RUN apk add --no-cache bash git curl tar && \
    mkdir /code

WORKDIR /code

ENV archive_githuburl https://github.com/CachetHQ/Cachet.git

RUN git clone $archive_githuburl --depth 1 && rm -rf Cachet/.git

FROM nginx:1.17.4-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk upgrade \
    && apk add --no-cache bash tzdata curl \
    && sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd \
    && ln -sf /usr/share/zoneinfo/\${TZ} /etc/localtime \
    && echo \${TZ} > /etc/timezone \
    && date \
    && apk del --no-cache tzdata \
    && rm -rf /var/cache/apk/*

EXPOSE 8000

CMD ["/sbin/entrypoint.sh"]

RUN apk add --no-cache --update \
    postgresql-client \
    postgresql \
    mysql-client \
    php7 \
    php7-redis \
    php7-apcu \
    php7-bcmath \
    php7-dom \
    php7-ctype \
    php7-curl \
    php7-fpm \
    php7-fileinfo \
    php7-gd \
    php7-iconv \
    php7-intl \
    php7-json \
    sqlite \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqlnd \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-session \
    php7-sqlite3 \
    php7-simplexml \
    php7-soap \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \
    php7-tokenizer \
    wget sqlite git curl bash grep \
    supervisor

RUN adduser -S -s /bin/bash -u 1001 -G root www-data && \
    touch /var/run/nginx.pid && \
    chown -R www-data:root /var/run/nginx.pid /etc/php7/php-fpm.d && \
    mkdir -p /var/www/html && \
    mkdir -p /usr/share/nginx/cache && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/lib/nginx && \
    chown -R www-data:root /var/www /usr/share/nginx/cache /var/cache/nginx /var/lib/nginx/ && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/php7/error.log && \
    ln -sf /dev/stderr /var/log/php7/error.log

# Install composer
RUN wget https://getcomposer.org/download/1.9.0/composer.phar -O /bin/composer.phar && \
    php /bin/composer.phar config -g repo.packagist composer https://mirrors.aliyun.com/composer/

WORKDIR /var/www/html/

COPY --from=builder  /code/Cachet /var/www/html 

RUN chown -R www-data:root /var/www/html && \
    php /bin/composer.phar global require "hirak/prestissimo:^0.3" && \
    php /bin/composer.phar install -o && \
    rm -rf bootstrap/cache/* && \
#    grep "asset(mix" * -R | awk -F: '{print $1}' | xargs -I {} sed -i "s# asset(mix# secure_asset(mix#g" {} && \
#    grep " asset('/img" * -R | awk -F: '{print $1}' | xargs -I {} sed -i "s# asset('/img# secure_asset('/img#g" {} && \
#    sed -i "41 aURL::forceScheme('https');" /var/www/html/app/Foundation/Providers/AppServiceProvider.php && \
#    sed -i 's#URL::forceScheme#\\URL::forceScheme#g' /var/www/html/app/Foundation/Providers/AppServiceProvider.php && \
    \
    sed -i '156d' /var/www/html/app/Models/Schedule.php 
     

COPY conf/php-fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx-site.conf /etc/nginx/conf.d/default.conf
COPY conf/.env.docker /var/www/html/.env
COPY entrypoint.sh /sbin/entrypoint.sh

USER root

RUN chmod g+rwx /var/run/nginx.pid && \
    chmod -R g+rw /var/www /usr/share/nginx/cache /var/cache/nginx /var/lib/nginx/ /etc/php7/php-fpm.d storage

USER 1001
