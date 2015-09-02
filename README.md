# What is it?
This is an ownCloud image based on Ubuntu 15.04, nginx, php5-fpm and configured for speed and security.
# Usage
Create data folders for permanent storage
```
mkdir /path/to/my/owncloud_data && chown www-data:www-data /path/to/my/owncloud_data
mkdir /path/to/my/mysql_data
```

Run a MySQL/MariaDB container
```
docker run --name mariadb -e MYSQL_ROOT_PASSWORD=some_password \
-v /path/to/my/mysql_data:/var/lib/mysql -d mariadb
```

Run the ownCloud container
```
docker run --name owncloud -i -p 80:80 -p 443:443 -e OC_ADMIN_USER=username \
-e OC_ADMIN_PASS=password -e OC_DB_NAME=dbname -e OC_TZ=timezone \
-e OC_SERVER_NAME=somename.com -v /path/to/ssl/crt:/etc/ssl/nginx \
-v /path/to/my/owncloud_data:/var/lib/owncloud --link mariadb -d tapir/owncloud
```

Where
* ` OC_ADMIN_USER ` is ownCloud admin user.
* ` OC_ADMIN_PASS ` is ownCloud admin password.
* ` OC_DB_NAME ` is ownCloud database name. It will be created automatically if it doesn't exists.
* ` OC_TZ ` timezone file as in `/usr/share/zoneinfo`. For example `-e OC_TZ=Europe/Istanbul` will set the container time to Istanbul. This is optional and can be omitted.
* ` OC_SERVER_NAME ` is the domain name of your server. If omitted ` localhost ` will be used.
* ` /path/to/ssl/crt ` is where you put your SSL key and certificate. If you don't mount this volume, a key and a cerfiticate will be automatically generated. The files should be named as `nginx.key`and `nginx.crt`.
