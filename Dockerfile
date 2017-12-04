FROM ubuntu:16.04
LABEL maintainer="cnbrucehong@icloud.com"

ENV BASE_PROJECT_DIR /home/web/code
ENV SHELL zsh

#ADD packages/sources.list /etc/apt/sources.list
RUN echo "Asia/Shanghai" > /etc/timezone
RUN mkdir -p $BASE_PROJECT_DIR

# 添加PPA源
RUN apt-get update && apt-get install -y software-properties-common zsh wget curl git vim language-pack-zh-hans
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN add-apt-repository ppa:nginx/stable
ADD packages/mysql-apt-config_0.8.9-1_all.deb /tmp/
RUN dpkg -i /tmp/mysql-apt-config_0.8.9-1_all.deb

# 安装zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh
RUN git config --global --add oh-my-zsh.hide-dirty 1

# 安装Nginx
RUN apt-get update && apt-get install -y nginx
ADD nginx/default /etc/nginx/sites-available/
ADD nginx/nginx.conf /etc/nginx/

# 安装 PHP
RUN apt-get update && apt-get install -y \
php7.1-fpm        php7.1-cli        php7.1-dev        php7.1-tidy       php7.1-zip        php7.1-snmp        \
php7.1-bcmath     php7.1-common     php7.1-enchant    php7.1-imap       php7.1-ldap       php7.1-odbc        \
php7.1-pspell     php7.1-soap       php7.1-xml        php7.1-bz2        php7.1-curl       php7.1-interbase   \
php7.1-mbstring   php7.1-opcache    php7.1-readline   php7.1-sqlite3    php7.1-xmlrpc     php7.1-dba         \
php7.1-gd         php7.1-intl       php7.1-mcrypt     php7.1-pgsql      php7.1-recode     php7.1-sybase      \
php7.1-xsl        php7.1-gmp        php7.1-json       php7.1-mysql      php7.1-phpdbg

ADD php/www.conf /etc/php/7.1/fpm/pool.d/
ADD php/php-fpm.conf /etc/php/7.1/fpm/

# PHPUnit
ADD php/packages/phpunit-5.6.2.phar /usr/local/bin/phpunit

# Composer
ADD php/packages/composer.phar /usr/local/bin/composer

# 安装 Supervisor
RUN apt-get -y install supervisor \
    && mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisor/conf.d

# supervisor base configuration
ADD supervisor/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf
ADD supervisor/nginx.conf /etc/supervisor/conf.d/nginx.conf
#ADD supervisor/nginx.conf /etc/supervisor/conf.d/mysql.conf
ADD supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 安装 Mysql
#RUN apt-get install mysql-server-5.7

#减少Ubuntu镜像大小
RUN apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /etc/php/5.5 /etc/php/5.6 /etc/php/7.0

ADD packages/sources.list /etc/apt/sources.list

WORKDIR $BASE_PROJECT_DIR

EXPOSE 80 9000 808

VOLUME ["$BASE_PROJECT_DIR"]

# 初始化挂载信息
CMD ["/usr/bin/supervisord"]