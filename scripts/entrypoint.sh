#!/bin/bash
#set -e

green="\033[00;32m"
red="\033[0;31m"
txtrst="\033[00;0m"

#service nginx start
#service fail2ban start
#service netfilter-persistent start
#service iptables stop 2>/dev/null
#service firewalld start

# Subir o serviço do vpbx-setup
if [ ! -f /var/lib/vitalpbx/dbsetup-done ]; then
  /usr/share/vitalpbx/scripts/setup_environment
  touch /var/lib/vitalpbx/dbsetup-done
fi

exec /lib/systemd/systemd
