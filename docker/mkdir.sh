#!/bin/bash

cd `dirname $0`
if [ ! -e ".env" ]; then
    echo ".env ファイルが存在しません"
    exit
fi
source ./.env

mydir=$(pwd)

echo '開始'

# データ配置ディレクトリを作成する
mkdir -p -m 775 -v ${DIR_LOCAL_DATA}

# 媒体データディレクトリを作成
cd ${mydir}; cd ${DIR_LOCAL_DATA}
mkdir -p -m 775 -v 000

# 入稿ディレクトリとログディレクトリを作成
cd ${mydir}; cd ${DIR_LOCAL_DATA}
mkdir -p -m 775 -v {input,log}

# 媒体000 の各パーツ格納ディレクトリを作成
cd ${mydir}; cd ${DIR_LOCAL_DATA}/000
mkdir -p -m 775 -v {image,parts_image,pdf,xml}

echo '完了'
