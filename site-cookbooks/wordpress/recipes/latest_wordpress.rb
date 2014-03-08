directory node["wordpress"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"

remote_file wordpress_latest do
  source "http://wordpress.org/latest.tar.gz"
  mode "0644"
end

execute "untar-wordpress" do
  cwd node['wordpress']['path']
  command "tar --strip-components 1 -xzf " + wordpress_latest
  creates node['wordpress']['path'] + "/wp-settings.php"
end

wordpress_site