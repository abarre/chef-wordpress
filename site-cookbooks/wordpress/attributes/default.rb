default['wordpress']['nginx_conf_name'] = "wordpress"
default['wordpress']['database'] = "wordpress"
default['wordpress']['db_username'] = "wordpress"
default['wordpress']['path'] = "/var/www/wordpress"
default['wordpress']['server_name'] = "wordpress"
default['php-fpm']['pool']['www']['listen'] = "/var/run/php-fpm-www.sock"
default['nginx']['version'] = '1.4.4'
default['nginx']['source']['modules'] = node['nginx']['source']['modules'] | ["nginx_with_pagespeed"]
