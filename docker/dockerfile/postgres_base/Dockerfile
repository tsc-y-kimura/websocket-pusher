FROM practice-laravel-websocket-pusher/base:2204

# apt-get による「debconf: delaying package configuration, since apt-utils is not installed」Warning が出ないようにする
ENV DEBCONF_NOWARNINGS=yes

# PostgreSQL のバージョン番号
ENV PGSQL_VER=14.5
# pg_bigm のバージョン番号
ENV PGBIGM_VER=1.2-20200228

# PostgreSQLのデータを格納するルートディレクトリ
ENV PGDATADIR=/var/lib/postgresql/data
# PostgreSQLのデータを格納するディレクトリ（/var/lib/postgresql/data/pgdata)
ENV PGDATA=$PGDATADIR/pgdata
# PostgreSQL関連の実行ファイルが格納されているディレクトリ
ENV PGSQLBIN=/opt/pgsql-${PGSQL_VER}/bin

# PostgreSQL関連の実行ファイルが格納されているディレクトリにパスを通す
ENV PATH=$PGSQLBIN:$PATH


# /usr/local/src/postgres-xxxx に移動
WORKDIR /usr/local/src/postgres-${PGSQL_VER}
# postgresql-xxxx.tar.gz をコピー
COPY postgresql-${PGSQL_VER}.tar.gz .

# libreadline-devライブラリ と zlib1g-dev(gzip関連)ライブラリをインストール
RUN apt-get update \
 && apt-get install -y libreadline-dev zlib1g-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# postgresql-xxxx.tar.gz を解凍してコンパイルする
RUN tar zxf postgresql-${PGSQL_VER}.tar.gz \
 && cd postgresql-${PGSQL_VER} \
 && ./configure --prefix=/opt/pgsql-${PGSQL_VER} \
 && make \
 && make install

# /usr/local/src/postgres-xxxx に移動
WORKDIR /usr/local/src/postgres-${PGSQL_VER}
# pg_bigm-xxxx.tar.gz をコピー
COPY pg_bigm-${PGBIGM_VER}.tar.gz .

# pg_bigm-xxxx.tar.gz を解凍してコンパイルする
RUN tar zxf pg_bigm-${PGBIGM_VER}.tar.gz \
 && cd pg_bigm-${PGBIGM_VER} \
 && make USE_PGXS=1 PG_CONFIG=/opt/pgsql-${PGSQL_VER}/bin/pg_config \
 && make USE_PGXS=1 PG_CONFIG=/opt/pgsql-${PGSQL_VER}/bin/pg_config install

# postgres ユーザーを作成する（UID:999 home_dir:/home/postgres）
# RUN useradd -m --uid 999 --create-home --home-dir /home/posgtres postgres
RUN useradd -u 999 -m -d /home/postgres -p $(perl -e 'print crypt("Himitsu5", "\$6\$salt03")') postgres

# ポート番号 5432 を使うことを伝える
EXPOSE 5432

# /var/lib/postgresql に移動
WORKDIR /var/lib/postgresql
# data ディレクトリを作成する
RUN mkdir -p data && chmod 777 data && chown postgres:postgres data

# PostgreSQLを初期化するシェルスクリプトを /tmp にコピー
COPY docker-entrypoint-initdb.sh /tmp/.
# 実行権限を付ける
RUN chmod 777 /tmp/docker-entrypoint-initdb.sh

# pg_hba.conf と postgresql.conf を /tmp にコピーしておく
COPY pg_hba.conf /tmp/.
COPY postgresql.conf /tmp/.

# postgres ユーザーになる
USER postgres

# コンテナ起動時に /tmp/docker-entrypoint-initdb.sh を実行するようにする
ENTRYPOINT ["/tmp/docker-entrypoint-initdb.sh"]

# PostgreSQLを立ち上げてから、処理が終わらないようにする
# CMD $PGSQLBIN/pg_ctl -D $PGDATA start \
#  && tail -f /dev/null
