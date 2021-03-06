#!/usr/bin/env bash

# Ubuntu box provision

# for newer php
# add following to  /etc/apt/sources.list
# deb http://packages.dotdeb.org squeeze all
# deb-src http://packages.dotdeb.org squeeze all

wget http://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg

# for newrelic
# add following to  /etc/apt/sources.list
# deb http://apt.newrelic.com/debian/ newrelic non-free

wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -

apt-get -y update

# New Relic
apt-get install newrelic-sysmond
nrsysmond-config --set license_key=XXXXXXXXXXXXXX
/etc/init.d/newrelic-sysmond start

# local time
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime
# ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime

# git
apt-get -y install git-core

# php-fpm
apt-get -y install php5-fpm

# php extensions
apt-get -y install php-pear php5-cli php5-mysql php5-imap php5-gd php5-curl php5-mcrypt

# php-apc
apt-get -y install php-apc

# nginx
apt-get -y install nginx

# link vagrant folder to hosting folder
rm -rf /var/www
ln -sf /vagrant /var/www

# copy over configuration file (micro instance)
cp -f /vagrant/conf/nginx.conf /etc/nginx/
cp -f /vagrant/conf/virtual.conf /etc/nginx/conf.d/
cp -f /vagrant/conf/php-fpm.conf /etc/php5/fpm/
cp -f /vagrant/conf/www.conf /etc/php5/fpm/pool.d/

# install sysv-rc-conf (Ubuntu version of chkconfig)
apt-get -y install sysv-rc-conf

# autostart php-fpm & nginx
sysv-rc-conf nginx on
sysv-rc-conf php5-fpm on

# remember to change /etc/php5/fpm/php.ini => short_open_tag = On

# start php-fpm & nginx
service nginx start
service php5-fpm start
service php5-fpm restart