#!/bin/bash

if [ -e /install.sh ]; then
	sh /install.sh
	rm -f /install.sh
	rm -f /fix_perms.sh
	rm -f /settings.php
fi

/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
