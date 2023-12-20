FROM ubuntu:20.04

# apt-get による「debconf: delaying package configuration, since apt-utils is not installed」Warning が出ないようにする
ENV DEBCONF_NOWARNINGS=yes

# タイムゾーンを Asia/Tokyo にする
RUN apt-get update \
 && apt-get install -y tzdata locales \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ベースイメージに含めたいライブラリをインストール
RUN apt-get update \
 && apt-get install -y build-essential make vim iputils-ping net-tools language-pack-ja-base language-pack-ja \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# .vimrc をコピー
COPY .vimrc /root/.vimrc

# RUN locale-gen en_US.UTF-8  
# ENV LANG en_US.UTF-8  
# ENV LANGUAGE en_US:en  
# ENV LC_ALL en_US.UTF-8

# 日本語環境にする
RUN locale-gen ja_JP.UTF-8
RUN echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc
ENV LANG ja_JP.UTF-8  
ENV LANGUAGE ja_JP:ja 
ENV LC_ALL ja_JP.UTF-8
