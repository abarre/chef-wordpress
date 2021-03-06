define :wordpress_site,
	:db_password => nil,
	:database => "wordpress",
	:db_username => "root",
	:path => "/var/www/wordpress",
	:nginx_conf_name => "wordpress",
	:server_name => "wordpress",
	:root_domain => "wordpress",
	:ssl => false,
	:nginx_conf_code => nil do

	include_recipe "database::mysql"

	::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

	mysql_password = params[:db_password] || secure_password

	mysql_connection_info = {:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']}

	mysql_database params[:database] do
	  connection mysql_connection_info
	  action [:create]
	end

	mysql_database_user params[:db_username] do
	  connection mysql_connection_info
	  password mysql_password
	  database_name params[:database]
	  privileges [:select,:update,:insert,:create,:delete]
	  action :grant
	end

	directory params[:path] do
	  owner "www-data"
	  group "www-data"
	  mode "0755"
	  action :create
	  recursive true
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

	template params[:path] + '/wp-config.php' do
	  source 'wp-config.php.erb'
	  cookbook 'wordpress-app'
	  mode 0755
	  owner 'www-data'
	  group 'www-data'
	  variables(
	    :database        => params[:database],
	    :user            => params[:db_username],
	    :password        => mysql_password,
	    :auth_key        => node['wordpress']['keys']['auth'],
	    :secure_auth_key => node['wordpress']['keys']['secure_auth'],
	    :logged_in_key   => node['wordpress']['keys']['logged_in'],
	    :nonce_key       => node['wordpress']['keys']['nonce'],
	    :auth_salt        => node['wordpress']['salt']['auth'],
	    :secure_auth_salt => node['wordpress']['salt']['secure_auth'],
	    :logged_in_salt   => node['wordpress']['salt']['logged_in'],
	    :nonce_salt       => node['wordpress']['salt']['nonce'],
	    :ssl              => params[:ssl]
	  )
	end

	pagespeed_conf = """
		# Ensure requests for pagespeed optimized resources go to the pagespeed handler
		# and no extraneous headers get set.
		location ~ \"\\.pagespeed\.([a-z]\\.)?[a-z]{2}\\.[^.]{10}\\.[^.]+\" {add_header \"\" \"\";}
		location ~ \"^/ngx_pagespeed_static/\" { }
		location ~ \"^/ngx_pagespeed_beacon$\" { }
		location /ngx_pagespeed_statistics { }
		location /ngx_pagespeed_global_statistics { }
		location /ngx_pagespeed_message { }
		location /pagespeed_console { }
		location ~ ^/pagespeed_admin { }
		location ~ ^/pagespeed_global_admin { }
	"""

	ssl_conf = ""

	if params[:ssl]
		ssl_conf = """
	  # Necessary for Let's Encrypt Domain Name ownership validation
	  location ^~ /.well-known {
	    try_files $uri =404;
	  }
	  location / {
	  	add_header X-Debug $http_x_forwarded_proto;
	  	if ($http_x_forwarded_proto != \"https\") {
		  	return 301 https://$host$request_uri;
		  }
	    index index.php;
			try_files $uri $uri/ /index.php?$args;
	  }
	  """
	else
		ssl_conf = """
			location / {
			  index index.php;
			  try_files $uri $uri/ /index.php?$args;
			}
		"""
	end

	wordpress_nginx_site params[:nginx_conf_name] do
	  host params[:server_name]
	  root params[:path]
	  code (params[:nginx_conf_code] || "") + pagespeed_conf + ssl_conf
	end

	if params[:ssl]
		certbot_self_signed_certificate params[:nginx_conf_name] do
		  conf_name params[:nginx_conf_name]
		  domains params[:server_name]
		end

		template "#{node['nginx']['dir']}/sites-available/#{params[:nginx_conf_name]}_ssl" do
	    source   'ssl_nginx_vhost.conf.erb'
	    owner    'root'
	    group    'root'
	    mode     00644
	    cookbook "wordpress-app"
	    variables(
	      :server_name => params[:server_name],
	      :cert_folder => "#{node[:certbot][:working_dir]}/live/#{params[:root_domain]}"
	    )
	    notifies :reload, "service[nginx]", :immediately                # when nginx is reloaded, it will point to the new valid certificates
	  end

	  nginx_site "#{params[:nginx_conf_name]}_ssl" do
	    enable true
	  end

		certbot_certificate params[:nginx_conf_name] do
		  conf_name params[:nginx_conf_name]
		  domains params[:server_name]
		  email "anthony.barre87@gmail.com"
		  notifies :reload, "service[nginx]", :immediately                # when nginx is reloaded, it will point to the new valid certificates
		end

	end
end
