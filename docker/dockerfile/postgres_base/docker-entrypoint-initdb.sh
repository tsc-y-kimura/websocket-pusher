#!/bin/bash

if [ -e ${PGDATA} ]; then   # 既にDBのデータ（を格納するディレクトリ）が存在する場合

    echo "既にDBのデータが存在するので、初期化はしません。"

else                        # DBデータが存在しないので初期化をする
    # DBの初期化
    echo "DBの初期化をします"
    initdb -D ${PGDATA} --locale=C --encoding=UTF8

    # 一旦起動する
    echo "DBを起動します（初回）"
    pg_ctl -D ${PGDATA} start

    # 起動するまで少し待つ（これを入れないと、後の psql コマンドが失敗する）
    sleep 5

    # DBに pg_bigm をセットする
    echo "pg_bigm をセット"
    psql -c "CREATE EXTENSION pg_bigm"

    # データベースを作成する
    echo "データベース「${DB_NAME}」を作成"
    psql -c "CREATE DATABASE ${DB_NAME}"

    # ユーザー名とパスワードを設定
    echo "ユーザー名「${DB_USER}」とパスワード「${DB_PASS}」を設定"
    psql -c "CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASS}'"

    # 作成したデータベースのオーナーを変更する
    echo "データベース「${DB_NAME}」のオーナーを「${DB_USER}」に変更"
    psql -c "ALTER DATABASE ${DB_NAME} OWNER TO ${DB_USER}"

    # 作成したデータベースに pg_bigm をセットする
    echo "データベースに pg_bigm をセット"
    psql -d ${DB_NAME} -c "CREATE EXTENSION pg_bigm"

    # 停止する
    echo "DBを停止します"
    pg_ctl -D ${PGDATA} stop
fi

# /var/lib/postgresql/data/pgdata に /tmp/pg_hba.conf と /tmp/postgresql.conf をコピーする
echo "「${PGDATA}」に pg_hba.conf と postgresql.conf をコピー"
cp /tmp/pg_hba.conf ${PGDATA}/.
cp /tmp/postgresql.conf ${PGDATA}/.

# postmaster.pid ファイルがあったら消す
if [ -e ${PGDATA}/postmaster.pid ]; then
    echo "「${PGDATA}/postmaster.pid」ファイルが存在するため、削除します"
    rm ${PGDATA}/postmaster.pid
fi

# DBを起動する
echo "DBを起動します"
pg_ctl -D ${PGDATA} start

# 終了しないようにする
echo "終了しないようにします"
tail -f /dev/null
