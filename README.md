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
* <code> OC_ADMIN_USER </code> is ownCloud admin user.
* <code> OC_ADMIN_PASS </code> is ownCloud admin password.
* <code> OC_DB_NAME </code> is ownCloud database name. It will be created automatically if it doesn't exists.
* <code> OC_TZ </code> timezone file as in <code>/usr/share/zoneinfo</code>. For example <code>-e OC_TZ=Europe/Istanbul</code> will set the container time to Istanbul. This is optional and can be omitted.
* <code> OC_SERVER_NAME </code> is the domain name of your server. If omitted <code> localhost </code> will be used.
