# It's prefered to not use "include_recipe mysql::server" that don't load the my.cnf file
# before launching the service.

package 'debconf-utils' do
	action :install
end

directory '/var/cache/local/preseeding' do
	owner 'root'
	group 'root'
	mode '0755'
	action :create
	recursive true
end

template '/var/cache/local/preseeding/mysql-server.seed' do
  source 'mysql-preseed.erb'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
  notifies :run, 'execute[preseed mysql-server]', :immediately
end

execute 'preseed mysql-server' do
  command '/usr/bin/debconf-set-selections /var/cache/local/preseeding/mysql-server.seed'
  action :nothing
end

include_recipe "mysqld"

execute 'assign-root-password' do
  cmd = "/usr/bin/mysqladmin"
  cmd << ' -u root password '
  cmd << Shellwords.escape(node[:mysql][:server_root_password])
  command cmd
  action :run
  only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

template '/etc/mysql_grants.sql' do
  source 'mysql-grants.sql.erb'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
  notifies :run, 'execute[install-grants]'
end

execute 'install-grants' do
  cmd = "/usr/bin/mysql"
  cmd << ' -u root '
  cmd << "-p" + Shellwords.escape(node[:mysql][:server_root_password]) + " < /etc/mysql_grants.sql"
  command cmd
  action :nothing
end