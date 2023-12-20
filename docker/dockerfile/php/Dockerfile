FROM php:8.3.1RC3-fpm
# FROM php:8.1.10-fpm

# apt-get による「debconf: delaying package configuration, since apt-utils is not installed」Warning が出ないようにする
ENV DEBCONF_NOWARNINGS=yes

# タイムゾーンを Asia/Tokyo にする
RUN apt-get update \
 && apt-get install -y tzdata locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# tscadminユーザ（UID:1000）を作成して、tscadminグループに www-dataユーザを属させる
RUN useradd -m --uid 1000 tscadmin && usermod -aG tscadmin www-data

# カレントディレクトリを移動
# WORKDIR /etc
WORKDIR /usr/local/etc/php
# php.ini をコピー
COPY ./php.ini .

# 空のエラーログファイルを作成しておき、書き込み可能にしておく
RUN touch /var/log/fpm-php.www.log && chmod 777 /var/log/fpm-php.www.log

# カレントディレクトリを移動
WORKDIR /usr/local/etc/php-fpm.d
# www.conf をコピー
COPY ./www.conf .

# カレントディレクトリを移動
WORKDIR /usr/local/bin
# composer をコピー
# COPY ./composer_2.5.5 ./composer
COPY ./composer_2.6.6 ./composer
# composer を実行可能にする
RUN chmod 775 /usr/local/bin/composer
# composer を最新にする
RUN composer self-update

# カレントディレクトリを移動
WORKDIR /var/lib/php

RUN set -ex apk --no-cache add postgresql-dev libpq-dev

# RUN sed -i '/jessie-updates/d' /etc/apt/sources.list

# phpライブラリやクーロンやnpmなどをインストール
RUN apt-get update \
  && apt-get install -y libpq-dev zlib1g-dev libpng-dev libjpeg62-turbo-dev libonig-dev libzip-dev libfreetype6-dev poppler-utils imagemagick \
  && docker-php-ext-install pdo_mysql pdo_pgsql mysqli zip \
  && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && apt-get install -y cron \
  && apt-get install -y nodejs npm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# カレントディレクトリを移動
WORKDIR /etc/cron.d
# cron をコピー
COPY cron .
# cron の権限を 644 にする（こうしないとクーロンが動かない）
RUN chmod 0644 /etc/cron.d/cron

# カレントディレクトリを移動
WORKDIR /tmp
# service.sh をコピー
COPY service.sh .
# service.sh を実行可能にする
RUN chmod 777 service.sh

# ln.sh をコピー
COPY ln.sh .
# ln.sh を実行可能にする
RUN chmod 777 ln.sh

# create_vendor_node_modules.sh をコピーしておく
COPY create_vendor_node_modules.sh .
# 実行権限を付けておく
RUN chmod 777 create_vendor_node_modules.sh

# php_artisan.sh をコピーしておく
COPY php_artisan.sh .
# 実行権限を付けておく
RUN chmod 777 php_artisan.sh

# シンボリックリンクを張って、service.sh を実行する
# CMD ln -s ${SYMLINK_SRC} ${SYMLINK_DST} \
#  && /tmp/service.sh
CMD /tmp/ln.sh ${SYMLINK_SRC} ${SYMLINK_DST} \
&& /tmp/service.sh
