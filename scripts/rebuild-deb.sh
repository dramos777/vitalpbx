#!/usr/bin/env bash

apt install vitalpbx --download-only -y \
	&& mkdir /tmp/rebuild-logger-core && dpkg-deb -R /var/cache/apt/archives/logger-core_* /tmp/rebuild-logger-core \
	&& sed -i '/systemctl/s/^/#/' /tmp/rebuild-logger-core/DEBIAN/postinst \
	&& dpkg-deb -b /tmp/rebuild-logger-core /tmp/logger-core.deb \
	&& dpkg -i /tmp/logger-core.deb \
	&& mkdir /tmp/rebuild-vitalpbx && dpkg-deb -R /var/cache/apt/archives/vitalpbx_* /tmp/rebuild-vitalpbx \
	&& sed -i '/systemctl/s/^/#/' /tmp/rebuild-vitalpbx/DEBIAN/postinst \
	&& dpkg-deb -b /tmp/rebuild-vitalpbx /tmp/vitalpbx.deb \
	&& dpkg -i /tmp/vitalpbx.deb 
