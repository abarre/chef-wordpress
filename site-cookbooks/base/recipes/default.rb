include_recipe "monit"
include_recipe "monit::ubuntu12fix"
include_recipe "monit::ssh"
include_recipe "ssmtp"
include_recipe "newrelic"
include_recipe "backup-manager"
include_recipe "unattended_upgrades"

monitrc "sys" do
  template_cookbook "base"
end

swap_file '/mnt/swap' do
  size      4096    # MBs
  persist 	true
end

package 'htop'
package 'unzip'
package 'curl'

template '/etc/cron.daily/backup-manager' do
  source 'backup-manager'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Configure certbot repository
apt_repository "certbot" do
  uri "http://ppa.launchpad.net/certbot/certbot/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "75BCA694"
  action :add
end
execute "apt-get update"

include_recipe "certbot"
