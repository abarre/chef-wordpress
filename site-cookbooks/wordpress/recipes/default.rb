#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_pagespeed"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "php::module_apc"
include_recipe "database::mysql"

directory "/var/cache/mod_pagespeed" do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

mysql_password = node['wordpress']['db_password'] || secure_password

mysql_connection_info = {:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']}

mysql_database node['wordpress']['database'] do
  connection mysql_connection_info
  action [:drop, :create]
end

mysql_database_user node['wordpress']['db_username'] do
  connection mysql_connection_info
  password mysql_password
  database_name node['wordpress']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

# API keys & salt for wp-config
node.set_unless['wordpress']['keys']['auth']         = secure_password
node.set_unless['wordpress']['keys']['secure_auth']  = secure_password
node.set_unless['wordpress']['keys']['logged_in']    = secure_password
node.set_unless['wordpress']['keys']['nonce']        = secure_password
node.set_unless['wordpress']['salt']['auth']        = secure_password
node.set_unless['wordpress']['salt']['secure_auth'] = secure_password
node.set_unless['wordpress']['salt']['logged_in']   = secure_password
node.set_unless['wordpress']['salt']['nonce']       = secure_password

template node['wordpress']['path'] + '/wp-config.php' do
  source 'wp-config.php.erb'
  mode 0755
  owner 'root'
  group 'root' 
  variables(
    :database        => node['wordpress']['database'],
    :user            => node['wordpress']['db_username'],
    :password        => mysql_password,
    :dbprefix        => node['wordpress']['database']['prefix'],
    :auth_key        => node['wordpress']['keys']['auth'],
    :secure_auth_key => node['wordpress']['keys']['secure_auth'],
    :logged_in_key   => node['wordpress']['keys']['logged_in'],
    :nonce_key       => node['wordpress']['keys']['nonce'],
    :auth_salt        => node['wordpress']['salt']['auth'],
    :secure_auth_salt => node['wordpress']['salt']['secure_auth'],
    :logged_in_salt   => node['wordpress']['salt']['logged_in'],
    :nonce_salt       => node['wordpress']['salt']['nonce']
  )
end

web_app 'wordpress' do
  template 'site.conf.erb'
  docroot node['wordpress']['path']
  server_name node['wordpress']['server_name']
end