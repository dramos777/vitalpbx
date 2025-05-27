FROM debian:bookworm-slim
COPY ./scripts/vitalpbx-dependences.sh /usr/local/bin/vitalpbx-dependences.sh
COPY ./scripts/pbx_installer.sh /usr/local/bin/pbx_installer.sh
COPY ./scripts/rebuild-deb.sh /usr/local/bin/rebuild-deb.sh

## Evita problemas de front-end ao instalar pacotes com systemd
ENV DEBIAN_FRONTEND=noninteractive
ENV PACKAGES="systemd \
                systemd-sysv \
	      	firewalld \
	      	fail2ban \
		iproute2 \
		iptables \
		sudo \
		curl \
		gpg \
		cron"

# Instala systemd e serviços desejados
RUN apt-get update \
    && apt-get install -y $PACKAGES \
    && find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -print0 | xargs -0 rm -vf \
    && curl -fsSL https://repo.vitalpbx.com/vitalpbx/v4.5/apt/setup_repo | bash - \
    && apt update -y \
    && chmod +x /usr/local/bin/vitalpbx-dependences.sh \
    && vitalpbx-dependences.sh \
    && chmod +x /usr/local/bin/pbx_installer.sh \
    && chmod +x /usr/local/bin/rebuild-deb.sh \
    && pbx_installer.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80 443 5060 5061 5062 7060 7061 7062
EXPOSE 18000-20000/udp

# Inicializa com systemd
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
