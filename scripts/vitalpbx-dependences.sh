#!/usr/bin/env bash

PACKAGES="dnsmasq-base \
asterisk-pbx-sounds-es-mx \
runit-helper \
dnsmasq \
libmpfr6 \
gawk \
galera-4 \
lsof \
mariadb-client-core \
mariadb-client \
mariadb-server-core \
rsync \
socat \
mariadb-server \
php8.2-igbinary \
php8.2-redis \
php-redis \
redis-tools \
redis-server \
odbcinst \
odbc-mariadb \
unixodbc \
dmidecode \
dos2unix \
dns-root-data \
mariadb-plugin-provider-bzip2 \
mariadb-plugin-provider-lz4 \
mariadb-plugin-provider-lzma \
mariadb-plugin-provider-lzo \
mariadb-plugin-provider-snappy \
pv"

apt-get update && apt-get install -y $PACKAGES --no-install-recommends
