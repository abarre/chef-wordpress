name             'wordpress'
maintainer       'Anthony Barre'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures wordpress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# depends "apache2"
depends "mysql"
depends "database"
depends "php"
depends "php-fpm"
depends "nginx"
depends "wordpress-nginx"
