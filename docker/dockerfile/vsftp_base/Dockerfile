FROM km6020/base:2204

# apt-get による「debconf: delaying package configuration, since apt-utils is not installed」Warning が出ないようにする
ENV DEBCONF_NOWARNINGS=yes

# vsftpのバージョン
ENV VSFTP_VER=3.0.3-12
# ftp ユーザー情報
ENV FTP_USER=tsc_ftp
ENV FTP_PASS=Himitsu5
# ftp ユーザーホームディレクトリ
ENV FTP_HOMEDIR=/var/www/km6020/input

# tscadmin ユーザーを作成する
RUN useradd -m --uid 1000 tscadmin

# FTPユーザを作成し、ホームディレクトリを設定する
# また、ユーザのパスワードも設定する
RUN useradd --home-dir ${FTP_HOMEDIR} ${FTP_USER} \
 && echo "${FTP_USER}:${FTP_PASS}" | chpasswd

# tscadminグループに FTPユーザーを属させる
RUN usermod -aG tscadmin ${FTP_USER}

# vsftpd をインストール
RUN apt-get update \
 && apt-get install -y vsftpd=${VSFTP_VER} \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# vsftpd.conf をセットする
COPY vsftpd.conf /etc/.

# /var/run/vaftpd/empty ディレクトリを作成する（書き込み権限を付けると '500 OOPS: vsftpd: refusing to run with writable root inside chroot()' エラーが出る）
RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

# 空の vsftpd.chroot_list ファイルを作成しておく 
RUN touch /etc/vsftpd.chroot_list

# 使用ポートを伝える
EXPOSE 21
# EXPOSE 50000-50009

# パッシブデータ（自ホストのIPアドレス、最小ポート番号、最大ポート番号）をvsftpd.confにセットして、vsftpd を実行
CMD echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd.conf \
 && echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd.conf \
 && echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd.conf \
 && /usr/sbin/vsftpd
 