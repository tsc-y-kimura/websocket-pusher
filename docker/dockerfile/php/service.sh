#!/bin/bash

# cron をバックグラウンドで実行
cron -f &

# php-fpm を実行
docker-php-entrypoint php-fpm