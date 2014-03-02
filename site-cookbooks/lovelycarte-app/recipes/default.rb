package "sshpass"

lovely_pass = search(:pass, "id:lovelycarte").first
lovely_cert = search(:certificate, "id:lovelycarte").first

import_lovelycarte = false

directory node["wordpress"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

log "copying the lovelycarte folder from the older server, it takes around 5 min the first time"

if import_lovelycarte
  pp node[:backup][:ip]
  execute 'copy the lovelycarte directory' do
    command "rsync -av --rsh='ssh -oStrictHostKeyChecking=no  -l root' #{node[:backup][:ip]}:/var/www/lovelycarte/* #{node['wordpress']['path']}"
  end

  execute 'export database' do
    command "ssh -oStrictHostKeyChecking=no root@#{node[:backup][:ip]} 'mysqldump -u root --password=#{node['mysql']['server_root_password']} lovelycarte' > /tmp/wordpress.sql"
  end
end

include_recipe "wordpress"

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

  rewrite ^/sitemap_index\.xml$ /index.php?sitemap=1 last;
  rewrite ^/([^/]+?)-sitemap([0-9]+)?\.xml$ /index.php?sitemap=$1&sitemap_n=$2 last;
"""

if import_lovelycarte
  # restore the backup
  mysql_database node['wordpress']['db_username'] do
    connection :host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']
    sql { ::File.open("/tmp/wordpress.sql").read }
    action :query
  end
end