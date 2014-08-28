name             'wordpress-server'
maintainer       'Anthony Barre'
maintainer_email 'anthony.barre87@gmail.com'
license          'All rights reserved'
description      'Installs/Configures a wordpress server'
long_description 'Varnish + Nginx + php-fpm + mysql = :)'
version          '0.1.0'

depends "mysql"
depends "php"
depends "php-fpm"
depends "nginx"
depends "nginx_with_pagespeed"
depends "wordpress-nginx"
depends "monit"
depends "credential"
depends "newrelic"
depends "varnish_for_passenger"