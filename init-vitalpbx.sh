#!/usr/bin/env bash

CONTAINER_NAME=vitalpbx
TZ="America/Fortaleza"

#docker container run --name=vitalpbx --privileged -ti --cgroupns=host --tmpfs /tmp --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:rw --device /dev/tty1 -p 80:80 -p 443:443 -d vitalpbx:0.5

docker container run --name=vitalpbx --privileged -ti --cgroupns=host \
	--tmpfs /tmp \
	--tmpfs /run \
	-v /sys/fs/cgroup:/sys/fs/cgroup:rw \
	-v data_vol:/var/lib/mysql \
	-v asterisk_vol:/etc/asterisk \
	-v /etc/localtime:/etc/localtime:ro \
	-v /etc/timezone:/etc/timezone:ro \
        -v ./image/logo.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/logo.png \
        -v ./image/logo-white.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/logo-white.png \
        -v ./image/vitxi_qr.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/vitxi_qr.png \
        -v ./image/mobile-logo-white.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/mobile-logo-white.png \
        -v ./image/logo-small.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/logo-small.png \
        -v ./image/pattern2.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/pattern2.png \
        -v ./image/sonata.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/sonata.png \
        -v ./image/avatar-dark.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/avatar-dark.png \
        -v ./image/pattern.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/pattern.png \
        -v ./image/avatar.png:/usr/share/vitalpbx/www/themes/vital_pbx/img/avatar.png \
	--device /dev/tty0 \
	-p 80:80 -p 443:443 \
        -p 5060:5060/udp \
        -p 5061:5061/udp \
	-e TZ=$TZ \
	--hostname vitalpbx \
	-d vitalpbx:0.5

# Portas apresentando problema pra subir o container
#        -p 10000-20000:10000-20000/udp \
