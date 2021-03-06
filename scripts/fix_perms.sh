#!/bin/bash

ocpath='/usr/share/nginx/html/owncloud'
htuser='www-data'
htgroup='www-data'

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
chown -R root:${htuser} ${ocpath}/
chown -R root:${htuser} /var/lib/owncloud/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/
chown -R ${htuser}:${htgroup} ${ocpath}/logs/
chown -R ${htuser}:${htgroup} /var/lib/owncloud/data/
chown root:${htuser} ${ocpath}/.htaccess
chmod 0644 ${ocpath}/.htaccess
chmod -R 0750 /var/lib/owncloud