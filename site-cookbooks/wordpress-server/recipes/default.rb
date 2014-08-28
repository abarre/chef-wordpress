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

mysql_service node['mysql']['service_name'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  server_root_password node['mysql']['server_root_password']
  server_debian_password node['mysql']['server_debian_password']
  server_repl_password node['mysql']['server_repl_password']
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  remove_test_database node['mysql']['remove_test_database']
  root_network_acl node['mysql']['root_network_acl']
  version node['mysql']['version']
  template_source 'mysql-my.cnf'
  action :create
end

monitrc "nginx" do
  template_cookbook "wordpress-server"
end

monitrc "mysql" do
  template_cookbook "wordpress-server"
end

monitrc "php-fpm" do
  template_cookbook "wordpress-server"
end

monitrc "varnish" do
  template_cookbook "wordpress-server"
end

php_fpm_pool "www"