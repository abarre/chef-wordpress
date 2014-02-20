default['wordpress']['nginx_conf_name'] = "wordpress"
default['wordpress']['database'] = "wordpress"
default['wordpress']['db_username'] = "wordpress"
default['wordpress']['path'] = "/var/www/wordpress"
default['wordpress']['server_name'] = "wordpress"
default['php-fpm']['pool']['www']['listen'] = "/var/run/php-fpm-www.sock"
default['php']['ext_conf_dir'] = "/etc/php5/mods-available"

override['newrelic']['web_server']['service_name'] = "php-fpm"