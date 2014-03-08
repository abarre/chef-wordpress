wordpress_site do
  database node["thephonedressing"]["database"]
  db_username node["thephonedressing"]["db_username"]
  path node["thephonedressing"]["path"]
  nginx_conf_name node["thephonedressing"]["nginx_conf_name"]
  server_name node["thephonedressing"]["server_name"]
end
