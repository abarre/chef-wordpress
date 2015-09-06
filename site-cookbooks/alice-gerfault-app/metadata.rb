name             'alice-gerfault-app'
maintainer       'Anthony Barre'
license          'All rights reserved'
description      'Installs/Configures wordpress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "wordpress-app"
depends "chef-solo-search"