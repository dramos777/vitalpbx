#! /bin/sh

set -e

vitalpbx_group='vitalpbx'
storage_dir='/var/lib/vitalpbx'
app_log_dir='/var/log/vitalpbx'
www_dir='/usr/share/vitalpbx/www'

services="mariadb asterisk nginx cron firewalld"
#/usr/bin/systemctl daemon-reload >/dev/null 2>&1 || :

case "$1" in
  configure)
#    systemctl --quiet --now enable $services || :
#    systemctl --quiet enable vpbx-setup.service || :
  ;;

  abort-upgrade|abort-remove|abort-deconfigure)
  ;;

  *)
    echo "postinst called with unknown argument \`$1'" >&2
    exit 1
  ;;
esac

# new install (old version not set)
if [ "$1" = "configure" ] && [ -z "$2" ]; then
  unlink /etc/nginx/sites-enabled/default 2>&1
fi

#Delete dpkg-new files
rm -f "/etc/nginx/pbx-addons/*.dpkg-new"

# Rename vitxi and sonata-dialer if they exist
for file in /etc/nginx/pbx-addons/vitxi /etc/nginx/pbx-addons/sonata-dialer; do
    if [ -e "$file" ]; then
        mv "$file" "${file}.conf"
    fi
done

#Configure settings depending on package status (Updating, or New Installation)

# new install (old version not set)
if [ "$1" = "configure" ] && [ -z "$2" ]; then
  /usr/share/vitalpbx/scripts/setup_environment || :
# upgrade (old version set)
elif [ "$1" = "configure" ]; then
  /usr/share/vitalpbx/scripts/update_env || :
fi

for username in www-data asterisk; do
	if ! groups "$username" | grep -q -w "$vitalpbx_group"; then
		usermod --append -G "$vitalpbx_group" "$username"
		# Restart service to apply group changes:
		service=$username
		case "$service" in www-data) service=nginx;; esac
#		systemctl restart $service.service || :
	fi
done

setfacl -Rdm g:$vitalpbx_group:rw "$storage_dir"
setfacl -Rdm g:asterisk:rwx "$storage_dir"
setfacl -Rdm u:asterisk:rwx "$storage_dir"
setfacl -Rm u:asterisk:rwx "$storage_dir"
setfacl -Rm g:asterisk:rwx "$storage_dir"
# Make happy to asterisk with a full restart
#systemctl restart asterisk || :

chown www-data:www-data $www_dir
chown -R www-data:www-data $www_dir
chown www-data:www-data $app_log_dir/*.log

chown www-data:www-data /usr/share/vitalpbx
chmod 755 /usr/share/vitalpbx

chmod 755 $www_dir
find $www_dir -type f -exec chmod 644 {} \;
find $www_dir -type d -exec chmod 755 {} \;

#Fix Permissions
chmod +x -R /usr/sbin/vitalpbx
chmod +x /etc/update-motd.d/20-vitalpbx
chmod +x /var/lib/vitalpbx
chmod 775 /var/lib/pbx-licenses
chown www-data:$vitalpbx_group /var/lib/vitalpbx
chown www-data:$vitalpbx_group /var/lib/pbx-licenses
chown www-data:www-data /var/log/vitalpbx
chown asterisk:www-data /usr/share/vitalpbx/certificates
chmod 775 /usr/share/vitalpbx/certificates
chown www-data:www-data /var/lib/vitalpbx/addons
chown www-data:www-data /var/lib/vitalpbx/cache
chown -R www-data:www-data /etc/vitalpbx
chown www-data:www-data /var/lib/vitalpbx/static

if [ -d "/var/lib/vitalpbx/backup" ]; then
  chown www-data:www-data /var/lib/vitalpbx/backup
  chown -R www-data:www-data /var/lib/vitalpbx/backup
fi

#Configure Postfix
if [ ! -f /etc/postfix/main.cf ]; then
  cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf
fi

#Clean deprecated files
if [ "$1" = "configure" ]; then
  rm -f /etc/profile.d/vitalwelcome.sh || :
  rm -f /etc/cron.hourly/vpbx_check_disk
  rm -f /etc/cron.hourly/vpbx_dynamic_routing
fi

#Install Logger
/usr/share/vitalpbx-logs/artisan migrate --force

echo "" > /etc/motd || :

#Restart CRON
#systemctl restart cron || :

#Reload Services
#systemctl reload nginx || :
