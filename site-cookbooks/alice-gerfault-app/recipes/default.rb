package "sshpass"

import_app = false

directory node["alice-gerfault"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

if import_app
  log "copying the alice-gerfault folder from the older server, it takes around 5 min the first time"
  execute 'copy the alice-gerfault directory' do
    command "rsync -av --rsh='ssh -oStrictHostKeyChecking=no  -l root' #{node[:backup][:ip]}:/var/www/alice-gerfault.com/* #{node['alice-gerfault']['path']}"
  end

  execute 'export database' do
    command "ssh -oStrictHostKeyChecking=no root@#{node[:backup][:ip]} 'mysqldump -u root --password=#{node['mysql']['server_root_password']} alice-gerfault' > /tmp/wordpress.sql"
  end
end

wordpress_site do
  database node["alice-gerfault"]["database"]
  db_username node["alice-gerfault"]["db_username"]
  path node["alice-gerfault"]["path"]
  nginx_conf_name node["alice-gerfault"]["nginx_conf_name"]
  server_name node["alice-gerfault"]["server_name"]
end

if import_app
  # restore the backup
  mysql_database node['alice-gerfault']['db_username'] do
    connection :host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']
    sql { ::File.open("/tmp/wordpress.sql").read }
    action :query
  end
end

file "/etc/cron.d/alice-gerfault_update_cache" do
  owner "root"
  group "root"
  mode "0644"
  content "5,20,35,50 * * * * root /usr/bin/curl --silent 'http://alice-gerfault.com/?warm_cache=0lVH7C05Y'\n"
  action :create
end