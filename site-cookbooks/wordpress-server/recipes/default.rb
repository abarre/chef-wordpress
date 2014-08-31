# Configure Ondrej's PPA for php5
apt_repository "php5" do
  uri "http://ppa.launchpad.net/ondrej/php5/ubuntu/"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E5267A6C"
  action :add
end
execute "apt-get update"

include_recipe "varnish_for_passenger"
include_recipe "nginx::source"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "php::module_apc"
include_recipe "php-fpm"
include_recipe "newrelic::php-agent"
include_recipe "mysql-server"

directory "/var/lib/php5" do
  owner "root"
  group "root"
  mode '1733'
  action :create
end

monitrc "nginx" do
  template_cookbook "wordpress-server"
end

monitrc "php-fpm" do
  template_cookbook "wordpress-server"
end

monitrc "varnish" do
  template_cookbook "wordpress-server"
end

monitrc "mysql" do
  template_cookbook "wordpress-server"
end

php_fpm_pool "www"