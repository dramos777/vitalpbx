#!/usr/bin/env bash

apt update \
&& apt install -y dnsmasq-base \
&& apt install -y asterisk-pbx-sounds-es-mx \
&& apt install -y runit-helper \
&& apt install -y dnsmasq \
&& apt install -y libmpfr6 \
&& apt install -y gawk \
&& apt install -y galera-4 \
&& apt install -y lsof \
&& apt install -y mariadb-client-core \
&& apt install -y mariadb-client \
&& apt install -y mariadb-server-core \
&& apt install -y rsync \
&& apt install -y socat \
&& apt install -y mariadb-server \
&& apt install -y php8.2-igbinary \
&& apt install -y php8.2-redis \
&& apt install -y php-redis \
&& apt install -y redis-tools \
&& apt install -y redis-server \
&& apt install -y odbcinst \
&& apt install -y odbc-mariadb \
&& apt install -y unixodbc \
&& apt install -y dmidecode \
&& apt install -y dos2unix \
&& apt install -y dns-root-data \
&& apt install -y mariadb-plugin-provider-bzip2 \
&& apt install -y mariadb-plugin-provider-lz4 \
&& apt install -y mariadb-plugin-provider-lzma \
&& apt install -y mariadb-plugin-provider-lzo \
&& apt install -y mariadb-plugin-provider-snappy \
&& apt install -y pv
