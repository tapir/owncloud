#!/bin/bash
#This script only runs once to install and configure ownCloud
#Then it deletes itself.

# Set timezone
if [ ! -z "$OC_TZ" ]; then
	echo "Setting time..."
	ln -snf /usr/share/zoneinfo/${OC_TZ} /etc/localtime && echo ${OC_TZ} > /etc/timezone
fi

# Set server name
echo "Setting server name..."
if [ -z "$OC_SERVER_NAME" ]; then
	export OC_SERVER_NAME="localhost"
fi
sed -i -e "s/\${SN}/$OC_SERVER_NAME/" /etc/nginx/sites-available/default
sed -i -e "s/\${SN}/$OC_SERVER_NAME/" /settings.php

# Create SSL keys
keypath="/etc/ssl/nginx/nginx.key"
crtpath="/etc/ssl/nginx/nginx.crt"
sslpath="/etc/ssl/nginx"

if [ ! -d ${sslpath} ]; then
	mkdir ${sslpath}
fi

if [ -e ${keypath} ] && [ -e ${crtpath} ]; then
	echo "Using existing SSL key and certificate..."
else
	echo "Creating new SSL key and certificate..."
	openssl req \
		-new \
		-newkey rsa:2048 \
		-days 365 \
		-nodes -x509 \
		-subj "/C=/ST=/L=/O=/OU=/CN=$OC_SERVER_NAME" \
		-keyout ${keypath} \
		-out ${crtpath}
fi

# Install ownCloud
echo "Installing ownCloud..."
cd /usr/share/nginx/html/owncloud && \
sudo -u www-data php occ maintenance:install \
--database "mysql" \
--database-name ${OC_DB_NAME} \
--database-user root \
--database-pass ${MARIADB_ENV_MYSQL_ROOT_PASSWORD} \
--database-host mariadb \
--admin-user ${OC_ADMIN_USER} \
--admin-pass ${OC_ADMIN_PASS} && \

# Configure ownCloud
sudo -u www-data php occ background:cron && \
sudo -u www-data php /settings.php

# Fix permissions
sh /fix_perms.sh
