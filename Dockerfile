FROM ubuntu:vivid

MAINTAINER Cosku Bas <cosku.bas@gmail.com>

CMD ["/start.sh"]

# Install necessary packages (php5-apcu from Trusty repos doesn't work)
RUN apt-get update -y && apt-get install -y \
supervisor cron sudo bzip2 nginx wget php5-apcu php5-ldap php5-cli \
php5-fpm php5-mysql php5-gd php5-mcrypt php5-json php5-curl php5-intl \
php5-imagick php5-imap php5-gmp

# Copy configs and scripts
COPY configs/php.ini.fpm /etc/php5/fpm/php.ini
COPY configs/php.ini.cli /etc/php5/cli/php.ini
COPY configs/default /etc/nginx/sites-available/default
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY configs/www.conf /etc/php5/fpm/pool.d/www.conf
COPY configs/owncloud.cron /owncloud
COPY configs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/configure_owncloud.php /settings.php
COPY scripts/install.sh /install.sh
COPY scripts/fix_perms.sh /fix_perms.sh
COPY scripts/start.sh /start.sh
RUN chmod +x /start.sh

# Configure cron
RUN crontab -u www-data /owncloud
RUN rm -f /owncloud

# Deploy ownCloud files
RUN wget https://download.owncloud.org/community/owncloud-8.1.1.tar.bz2
RUN tar -jxvf owncloud-8.1.1.tar.bz2 -C /usr/share/nginx/html/
RUN rm -f owncloud-8.1.1.tar.bz2
RUN rm -Rf /usr/share/nginx/html/owncloud/core/skeleton/*
RUN mkdir /usr/share/nginx/html/owncloud/assets
RUN mkdir /usr/share/nginx/html/owncloud/logs
RUN mkdir /usr/share/owncloud
RUN chown -Rf www-data:www-data /usr/share/nginx/html/owncloud
RUN chown -Rf www-data:www-data /usr/share/owncloud
COPY configs/htaccess /usr/share/nginx/html/owncloud/.htaccess

# Clean up APT when done.
RUN apt-get remove --purge -y wget bzip2
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80 443
