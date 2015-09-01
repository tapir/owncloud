<?php

$filename = '/usr/share/nginx/html/owncloud/config/config.php';

require $filename;

$CONFIG['trusted_domains'] = array ( '${SN}' );
$CONFIG['overwritehost'] = '${SN}';
$CONFIG['memcache.local'] = '\OC\Memcache\APCu';
$CONFIG['asset-pipeline.enabled'] = true;
$CONFIG['logfile'] = '/usr/share/nginx/html/owncloud/logs/owncloud.log';
unset($CONFIG['overwrite.cli.url']);

$content = '<?php' . PHP_EOL . '$CONFIG = ' . var_export($CONFIG, true) . ';';
file_put_contents($filename, $content);

?>
