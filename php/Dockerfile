FROM alpine:edge as builder

LABEL maintainer="ysicing <i@ysicing.me>"

ARG PHP_VERSION=7.3.9
ARG GPG_KEYS="CBAF69F173A0FEA4B537F470D66C9593118BCCB6 F38252826ACD957EF380D39F2F7956BC5DA04B5D"
ARG COMPOSER_VERSION=1.9.0

RUN apk add --no-cache gnupg \
  && mkdir -p /usr/src \
  && cd /usr/src \
  && wget -O php.tar.xz https://secure.php.net/get/php-$PHP_VERSION.tar.xz/from/this/mirror \
  && wget -O php.tar.xz.asc https://secure.php.net/get/php-$PHP_VERSION.tar.xz.asc/from/this/mirror \
  && export GNUPGHOME="$(mktemp -d)"; \
  for key in $GPG_KEYS; do \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
  done \
  && gpg --batch --verify php.tar.xz.asc php.tar.xz

COPY docker-php-source /usr/local/bin/
ENV PHP_INI_DIR /usr/local/etc/php

RUN set -xe \
  && apk add --no-cache \
    autoconf \
    build-base \
    dpkg \
    dpkg-dev \
    pkgconf \
    re2c \
    argon2-dev \
    coreutils \
    curl-dev \
    libedit-dev \
    openssl-dev \
    libsodium-dev \
    libxml2-dev \
    sqlite-dev \
  \
  && export CFLAGS="-fstack-protector-strong -fpic -fpie -O3" \
    CPPFLAGS="-fstack-protector-strong -fpic -fpie -O3" \
    LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie" \
  && docker-php-source extract \
  && cd /usr/src/php \
  \
  && mkdir -p $PHP_INI_DIR/conf.d \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -G www-data www-data \
  \
  && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  && ./configure \
    --build="$gnuArch" \
    --with-config-file-path="$PHP_INI_DIR" \
    --with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
    --enable-option-checking=fatal \
    --with-mhash \
    --enable-ftp \
    --enable-mbstring \
    --enable-mysqlnd \
    --with-password-argon2 \
    --with-sodium=shared \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-zlib \
    --enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data \
    --disable-cgi \
  && make -j "$(nproc)" \
  && make install \
  && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
  && make clean \
  && cp -v php.ini-* "$PHP_INI_DIR/" \
  && cd / \
  && docker-php-source delete \
  \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
    | tr ',' '\n' \
    | sort -u \
    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
  && apk add --no-cache $runDeps

COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/

# pickle
RUN wget -O /usr/bin/pickle https://github.com/FriendsOfPHP/pickle/releases/download/v0.4.0/pickle.phar \
  && chmod a+x /usr/bin/pickle

# apcu
RUN (pickle install apcu -n --defaults || true) \
  && cd /tmp/apcu/apcu* \
  && phpize \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
	&& docker-php-ext-enable apcu \
	&& (rm -rf /usr/local/lib/php/test/apcu || true) \
	&& (rm -rf /usr/local/lib/php/doc/apcu || true)

# bcmath
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath \
	&& (rm -rf /usr/local/lib/php/test/bcmath || true) \
	&& (rm -rf /usr/local/lib/php/doc/bcmath || true)

# exif
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) exif \
	&& (rm -rf /usr/local/lib/php/test/exif || true) \
	&& (rm -rf /usr/local/lib/php/doc/exif || true)

# gd
RUN apk add --no-cache \
    libpng-dev \
    libwebp-dev \
    libjpeg-turbo-dev \
    libxpm-dev \
    freetype-dev \
  && docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir=/usr \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-zlib-dir=/usr \
    --with-xpm-dir=/usr \
    --with-freetype-dir=/usr \
    --enable-gd-jis-conv \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd \
	&& (rm -rf /usr/local/lib/php/test/gd || true) \
	&& (rm -rf /usr/local/lib/php/doc/gd || true)

# gettext
RUN apk add --no-cache \
    gettext-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gettext \
	&& (rm -rf /usr/local/lib/php/test/gettext || true) \
	&& (rm -rf /usr/local/lib/php/doc/gettext || true)

# gmp
RUN apk add --no-cache \
    gmp-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gmp \
	&& (rm -rf /usr/local/lib/php/test/gmp || true) \
	&& (rm -rf /usr/local/lib/php/doc/gmp || true)

# imagick
RUN apk add --no-cache \
    imagemagick-dev \
  && (pickle install imagick -n --defaults || true) \
  && cd /tmp/imagick/imagick* \
  && phpize \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && docker-php-ext-enable imagick \
	&& (rm -rf /usr/local/lib/php/test/imagick || true) \
	&& (rm -rf /usr/local/lib/php/doc/imagick || true)

# intl
RUN apk add --no-cache \
    icu-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
	&& (rm -rf /usr/local/lib/php/test/intl || true) \
	&& (rm -rf /usr/local/lib/php/doc/intl || true)

# memcached
RUN apk add --no-cache \
    libmemcached-dev \
  && (pickle install memcached -n --defaults || true) \
  && cd /tmp/memcached/memcached* \
  && phpize \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
	&& docker-php-ext-enable memcached \
	&& (rm -rf /usr/local/lib/php/test/memcached || true) \
	&& (rm -rf /usr/local/lib/php/doc/memcached || true)

# mysqli
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli \
	&& (rm -rf /usr/local/lib/php/test/mysqli || true) \
	&& (rm -rf /usr/local/lib/php/doc/mysqli || true)

# opcache
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) opcache \
	&& (rm -rf /usr/local/lib/php/test/opcache || true) \
	&& (rm -rf /usr/local/lib/php/doc/opcache || true)

# pcntl
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pcntl \
	&& (rm -rf /usr/local/lib/php/test/pcntl || true) \
	&& (rm -rf /usr/local/lib/php/doc/pcntl || true)

# pdo_mysql
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
	&& (rm -rf /usr/local/lib/php/test/pdo_mysql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_mysql || true)

# pdo_pgsql
RUN apk add --no-cache \
    postgresql-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_pgsql \
	&& (rm -rf /usr/local/lib/php/test/pdo_pgsql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_pgsql || true)

# pgsql
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql \
	&& (rm -rf /usr/local/lib/php/test/pgsql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pgsql || true)

# redis
RUN (pickle install redis -n --defaults || true) \
  && cd /tmp/redis/redis* \
	&& phpize \
  && ./configure \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
	&& docker-php-ext-enable redis \
	&& (rm -rf /usr/local/lib/php/test/redis || true) \
	&& (rm -rf /usr/local/lib/php/doc/redis || true)

# shmop
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) shmop \
	&& (rm -rf /usr/local/lib/php/test/shmop || true) \
	&& (rm -rf /usr/local/lib/php/doc/shmop || true)

# soap
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) soap \
	&& (rm -rf /usr/local/lib/php/test/soap || true) \
	&& (rm -rf /usr/local/lib/php/doc/soap || true)

# sockets
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sockets \
	&& (rm -rf /usr/local/lib/php/test/sockets || true) \
	&& (rm -rf /usr/local/lib/php/doc/sockets || true)

# sodium
RUN docker-php-ext-enable sodium \
	&& (rm -rf /usr/local/lib/php/test/sodium || true) \
	&& (rm -rf /usr/local/lib/php/doc/sodium || true)

# swoole
RUN (pickle install swoole -n --defaults || true) \
  && cd /tmp/swoole/swoole* \
	&& phpize \
  && ./configure \
    --enable-openssl \
    --enable-sockets \
    --enable-http2 \
    --enable-mysqlnd \
    --enable-coroutine-postgresql \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
	&& docker-php-ext-enable swoole \
	&& (rm -rf /usr/local/lib/php/test/swoole || true) \
	&& (rm -rf /usr/local/lib/php/doc/swoole || true)

# sysvsem
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sysvsem \
	&& (rm -rf /usr/local/lib/php/test/sysvsem || true) \
	&& (rm -rf /usr/local/lib/php/doc/sysvsem || true)

# tidy
RUN apk add --no-cache \
    tidyhtml-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) tidy \
	&& (rm -rf /usr/local/lib/php/test/tidy || true) \
	&& (rm -rf /usr/local/lib/php/doc/tidy || true)

# xmlrpc
RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) xmlrpc \
	&& (rm -rf /usr/local/lib/php/test/xmlrpc || true) \
	&& (rm -rf /usr/local/lib/php/doc/xmlrpc || true)

# xsl
RUN apk add --no-cache \
    libxslt-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) xsl \
	&& (rm -rf /usr/local/lib/php/test/xsl || true) \
	&& (rm -rf /usr/local/lib/php/doc/xsl || true)

# zip
RUN apk add --no-cache \
    libzip-dev \
  && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
	&& (rm -rf /usr/local/lib/php/test/zip || true) \
	&& (rm -rf /usr/local/lib/php/doc/zip || true)

# composer
RUN wget -O /usr/local/bin/composer https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar \
  && chmod a+x /usr/local/bin/composer

# strip extensions
RUN strip --strip-all `php-config --extension-dir`/*.so



FROM alpine:3.10

LABEL maintainer="ysicing <i@ysicing.me>"

COPY --from=builder /usr/local/ /usr/local/

RUN set -x \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/ \
    | tr ',' '\n' \
    | sort -u \
    | awk 'system("[ -e /usr/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
  && apk --no-cache add $runDeps \
  && addgroup -g 48 -S www-data \
  && adduser -u 990 -D -S -G www-data www-data \
  && cd /usr/local/etc \
  && if [ -d php-fpm.d ]; then \
      sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
      cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
    else \
      mkdir php-fpm.d; \
      cp php-fpm.conf.default php-fpm.d/www.conf; \
      { \
        echo '[global]'; \
        echo 'include=etc/php-fpm.d/*.conf'; \
      } | tee php-fpm.conf; \
    fi \
  && { \
      echo '[global]'; \
      echo 'error_log = /proc/self/fd/2'; \
      echo; echo '; https://github.com/docker-library/php/pull/725#issuecomment-443540114'; echo 'log_limit = 8192'; \
      echo; \
      echo '[www]'; \
      echo '; if we send this to /proc/self/fd/1, it never appears'; \
      echo 'access.log = /proc/self/fd/2'; \
      echo; \
      echo 'clear_env = no'; \
      echo; \
      echo '; Ensure worker stdout and stderr are sent to the main error log.'; \
      echo 'catch_workers_output = yes'; \
      echo 'decorate_workers_output = no'; \
    } | tee php-fpm.d/docker.conf \
  && { \
      echo '[global]'; \
      echo 'daemonize = no'; \
      echo; \
      echo '[www]'; \
      echo 'listen = 9000'; \
    } | tee php-fpm.d/zz-docker.conf \
  && { \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=4000'; \
      echo 'opcache.revalidate_freq=60'; \
      echo 'opcache.fast_shutdown=1'; \
      echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
  && { \
      echo 'memory_limit=256M'; \
      echo 'upload_max_filesize=50M'; \
      echo 'post_max_size=100M'; \
      echo 'max_execution_time=600'; \
      echo 'default_socket_timeout=3600'; \
      echo 'request_terminate_timeout=600'; \
    } > /usr/local/etc/php/conf.d/options.ini

WORKDIR /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]
