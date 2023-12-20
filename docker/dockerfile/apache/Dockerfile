FROM httpd:2.4.54

# apt-get による「debconf: delaying package configuration, since apt-utils is not installed」Warning が出ないようにする
ENV DEBCONF_NOWARNINGS=yes

# タイムゾーンを Asia/Tokyo にする
RUN apt-get update \
 && apt-get install -y tzdata locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# openssl をインストール
RUN apt-get update \
 && apt-get install -y openssl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# カレントディレクトリを移動
WORKDIR /usr/local/apache2/conf
# httpd.conf をコピー
COPY ./httpd.conf .
# 鍵をコピー
# COPY ./server.key .
# COPY ./server.crt .

# カレントディレクトリを移動
WORKDIR /usr/local/apache2/conf/extra
# httpd-ssl.conf をコピー
COPY ./httpd-ssl.conf .

# tscadmin ユーザー（UID:1000）を作成し、www-data ユーザーを tscadmin グループに属させる
RUN useradd -m --uid 1000 tscadmin && usermod -aG tscadmin www-data

# /var/www/html ディレクトリを作成
RUN mkdir -p /var/www/html && chmod 777 /var/www/html

# カレントディレクトリを移動
WORKDIR /tmp
# ln.sh をコピー
COPY ln.sh .
# ln.sh を実行可能にする
RUN chmod 777 ln.sh

# ポートは 80 と 443 を使用する
EXPOSE 80
EXPOSE 443

# シンボリックリンクを張って、httpd を起動
# CMD ln -s ${SYMLINK_SRC} ${SYMLINK_DST} \
#  && httpd-foreground
CMD /tmp/ln.sh ${SYMLINK_SRC} ${SYMLINK_DST} \
&& httpd-foreground
 