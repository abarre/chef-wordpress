default['php-fpm']['pool']['www']['listen'] = "/var/run/php-fpm-www.sock"
default['php']['ext_conf_dir'] = "/etc/php5/mods-available"

override['newrelic']['web_server']['service_name'] = "php-fpm"
default['wordpress_nginx']['static_file_expiry'] = '24d'
override['wordpress_nginx']['listen'] = default['varnish']['backend_port']
override['nginx']['default_site_enabled'] = false