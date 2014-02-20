name             'wordpress'
maintainer       'Anthony Barre'
maintainer_email 'anthony.barre87@gmail.com'
license          'All rights reserved'
description      'Installs/Configures wordpress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "mysql"
depends "database"
depends "php"
depends "php-fpm"
depends "nginx"
depends "nginx_with_pagespeed"
depends "wordpress-nginx"
depends "monit"
depends "credential"
depends "newrelic"