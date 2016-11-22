package "sshpass"

thephonedressing_cert = search(:certificate, "id:thephonedressing").first

thephonedressing_ssl_cert_chain_path = "#{node['nginx']['dir']}/conf.d/thephonedressing.com_chain.pem"
thephonedressing_ssl_cert_key_path = "#{node['nginx']['dir']}/conf.d/thephonedressing.com.key"

ssl_nginx_conf = """
  listen 443 ssl;
  ssl_certificate #{thephonedressing_ssl_cert_chain_path};
  ssl_certificate_key #{thephonedressing_ssl_cert_key_path};
"""

wordpress_site do
  database node["thephonedressing"]["database"]
  db_username node["thephonedressing"]["db_username"]
  path node["thephonedressing"]["path"]
  nginx_conf_name node["thephonedressing"]["nginx_conf_name"]
  server_name node["thephonedressing"]["server_name"]
  nginx_conf_code ssl_nginx_conf
end


#manage ssl on thephonedressing.com
file thephonedressing_ssl_cert_chain_path do
  owner "root"
  group "root"
  mode "0644"
  content thephonedressing_cert[:cert]
  action :create
end

file thephonedressing_ssl_cert_key_path do
  owner "root"
  group "root"
  mode "0644"
  content thephonedressing_cert[:key]
  action :create
end

file "/etc/cron.d/thephonedressing_update_cache" do
  owner "root"
  group "root"
  mode "0644"
  content "0,15,30,45 * * * * root /usr/bin/curl --silent 'http://thephonedressing.com/?warm_cache=K4Ydu2xOq'\n"
  action :create
end
