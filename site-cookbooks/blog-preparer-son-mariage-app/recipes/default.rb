package "sshpass"

import_app = false

directory node["blog-mariage"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

if import_app
  log "copying the blog-mariage folder from the older server, it takes around 5 min the first time"
  execute 'copy the blog-mariage directory' do
    command "rsync -av --rsh='ssh -oStrictHostKeyChecking=no  -l root' #{node[:backup][:ip]}:/var/www/blog-mariage.com/* #{node['blog-mariage']['path']}"
  end

  execute 'export database' do
    command "ssh -oStrictHostKeyChecking=no root@#{node[:backup][:ip]} 'mysqldump -u root --password=#{node['mysql']['server_root_password']} blog-mariage' > /tmp/wordpress.sql"
  end
end

wordpress_site do
  database node["blog-mariage"]["database"]
  db_username node["blog-mariage"]["db_username"]
  path node["blog-mariage"]["path"]
  nginx_conf_name node["blog-mariage"]["nginx_conf_name"]
  server_name node["blog-mariage"]["server_name"]
end

if import_app
  # restore the backup
  mysql_database node['blog-mariage']['db_username'] do
    connection :host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']
    sql { ::File.open("/tmp/wordpress.sql").read }
    action :query
  end
end

file "/etc/cron.d/blog-mariage_update_cache" do
  owner "root"
  group "root"
  mode "0644"
  content "5,20,35,50 * * * * root /usr/bin/curl --silent 'http://blog.preparer-son-mariage.fr/?warm_cache=0lVH7C05Y'\n"
  action :create
end