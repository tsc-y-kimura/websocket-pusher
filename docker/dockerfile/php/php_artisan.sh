#!/bin/bash

echo "処理開始"

# www-data ユーザーで実行する
su -s /bin/bash www-data << EOF
    # /var/www/xxxx_src に移動
    echo "/var/www/${1}_src に移動"
    cd /var/www/${1}_src

    # マイグレートする
    echo "php artisan migrate"
    php artisan migrate

    # シーダーを流す
    echo "php artisan db:seed"
    php artisan db:seed

    # public から storage へリンクを張る
    echo "php artisan storage:link"
    php artisan storage:link
EOF

echo "処理終了"
