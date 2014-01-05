package "sshpass"

lovely_pass = search(:pass, "id:lovelycarte").first
lovely_cert = search(:certificate, "id:lovelycarte").first

execute 'export database' do
  command "sshpass -p #{lovely_pass[:server]} ssh -oStrictHostKeyChecking=no anthonybarre@direct.preparer-son-mariage.fr -p 1337 'mysqldump -u root --password=#{lovely_pass[:mysql]} lovelycarte' > /tmp/wordpress.sql"
end

directory node["wordpress"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

log "copying the lovelycarte folder from the older server, it takes around 5 min the first time"

execute 'copy the lovelycarte directory' do
  command "rsync -av --rsh='sshpass -p #{lovely_pass[:server]} ssh -p 1337 -oStrictHostKeyChecking=no  -l anthonybarre' direct.preparer-son-mariage.fr:~/www/lovelycarte/* #{node['wordpress']['path']}"
end

lovelycarte_ssl_cert_chain_path = "#{node['nginx']['dir']}/conf.d/lovelycarte.com_chain.pem"
lovelycarte_ssl_cert_key_path = "#{node['nginx']['dir']}/conf.d/lovelycarte.com.key"

#manage ssl on lovelycarte.com
file lovelycarte_ssl_cert_chain_path do
  owner "root"
  group "root"
  mode "0644"
  content lovely_cert[:cert]
  action :create
end

file lovelycarte_ssl_cert_key_path do
  owner "root"
  group "root"
  mode "0644"
  content lovely_cert[:key]
  action :create
end

node.default["wordpress"]["nginx_conf_code"] = """
  listen 443 ssl;
  ssl_certificate #{lovelycarte_ssl_cert_chain_path};
  ssl_certificate_key #{lovelycarte_ssl_cert_key_path};
"""

include_recipe "wordpress"

# query a database from a sql script on disk
mysql_database node['wordpress']['db_username'] do
  connection :host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']
  sql { ::File.open("/tmp/wordpress.sql").read }
  action :query
end