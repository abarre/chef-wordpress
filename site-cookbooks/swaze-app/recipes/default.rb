wordpress_site do
  database node["swaze"]["database"]
  db_username node["swaze"]["db_username"]
  path node["swaze"]["path"]
  nginx_conf_name node["swaze"]["nginx_conf_name"]
  server_name node["swaze"]["server_name"]
end

file "/etc/cron.d/swaze_update_cache" do
  owner "root"
  group "root"
  mode "0644"
  content "5,20,35,50 * * * * root /usr/bin/curl --silent 'http://blog.preparer-son-mariage.fr/?warm_cache=K4Ydu2x0q'\n"
  action :create
end
