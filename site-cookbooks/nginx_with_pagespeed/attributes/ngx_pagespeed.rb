#
# Cookbook Name:: nginx
# Attributes:: ngx_pagespeed
#
# Author:: Achim Rosenhagen (<a.rosenhagen@ffuenf.de>)
#
# Copyright 2013, Achim Rosenhagen
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['nginx']['version'] = '1.4.4'
default['nginx']['source']['modules'] = node['nginx']['source']['modules'] | ["nginx_with_pagespeed"]

default['nginx']['ngx_pagespeed']['version']  = "1.7.30.1-beta"
default['nginx']['ngx_pagespeed']['url']      = "https://github.com/pagespeed/ngx_pagespeed/archive/v#{node['nginx']['ngx_pagespeed']['version']}.tar.gz"
default['nginx']['ngx_pagespeed']['src']['cookbook'] = "nginx"
default['nginx']['ngx_pagespeed']['src']['file'] = nil

default['nginx']['ngx_pagespeed']['psol']['version']  = "1.7.30.1"
default['nginx']['ngx_pagespeed']['psol']['url'] = "https://dl.google.com/dl/page-speed/psol/#{node['nginx']['ngx_pagespeed']['psol']['version']}.tar.gz"
default['nginx']['ngx_pagespeed']['psol']['src']['cookbook'] = "nginx"
default['nginx']['ngx_pagespeed']['psol']['src']['file'] = nil

default['nginx']['ngx_pagespeed']['FileCachePath'] = "/tmp/ngx_pagespeed_cache"
default['nginx']['ngx_pagespeed']['EnableFilters'] = "collapse_whitespace,combine_css,combine_javascript,remove_comments,move_css_above_scripts,move_css_to_head,convert_png_to_jpeg,convert_jpeg_to_webp"