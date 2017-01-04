FROM ubuntu:16.04
MAINTAINER cnbrucehong <cnbrucehong@icloud.com>

ENV BASE_PROJECT_DIR /home/web/code
ENV SHELL zsh

ADD sources.list /etc/apt/sources.list
RUN echo "Asia/Shanghai" > /etc/timezone
RUN mkdir -p $BASE_PROJECT_DIR

# 添加PPA源
RUN apt-get update && apt-get install -y software-properties-common python-software-properties zsh wget curl git language-pack-en-base
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:nginx/stable
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/mysql-5.7
RUN apt-get update

# setting up zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

# 安装Nginx
RUN apt-get install -y nginx

# 安装 PHP
RUN apt-get install -y php7.1-fpm php7.1-cli php7.1-dev \
php7.1-bcmath     php7.1-common     php7.1-enchant    php7.1-imap       php7.1-ldap       php7.1-odbc       php7.1-pspell     php7.1-soap       php7.1-xml \
php7.1-bz2        php7.1-curl       php7.1-interbase  php7.1-mbstring   php7.1-opcache    php7.1-readline   php7.1-sqlite3    php7.1-xmlrpc \
php7.1-dba        php7.1-gd         php7.1-intl       php7.1-mcrypt     php7.1-pgsql      php7.1-recode     php7.1-sybase     php7.1-xsl \
php7.1-gmp        php7.1-json       php7.1-mysql      php7.1-phpdbg     php7.1-snmp       php7.1-tidy       php7.1-zip

# PHPUnit
ADD php/packages/phpunit-5.6.2.phar /usr/local/bin/phpunit

# Composer
ADD php/packages/composer.phar /usr/local/bin/composer

# 安装 Mysql
