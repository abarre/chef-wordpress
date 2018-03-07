#include_recipe "varnish"

major_version_no_dot = node['varnish']['version'].to_s.tr('.', '')
apt_repository 'varnish-cache' do
  uri "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/#{node['platform']}/"
  distribution node['lsb']['codename']
  components ["main"]
  key "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/gpgkey"
  deb_src true
  notifies 'nothing', 'execute[apt-get update]', 'immediately'
end

package 'varnish'

template "#{node['varnish']['dir']}/#{node['varnish']['vcl_conf']}" do
  source node['varnish']['vcl_source']
  cookbook node['varnish']['vcl_cookbook']
  owner 'root'
  group 'root'
  mode 0644
  notifies :reload, 'service[varnish]'
  only_if { node['varnish']['vcl_generated'] == true }
end

template node['varnish']['default'] do
  source node['varnish']['conf_source']
  cookbook node['varnish']['conf_cookbook']
  owner 'root'
  group 'root'
  mode 0644
  notifies 'restart', 'service[varnish]'
end

service 'varnish' do
  supports restart: true, reload: true
  action %w(enable start)
end

service 'varnishlog' do
  supports restart: true, reload: true
  action %w(enable start)
end

