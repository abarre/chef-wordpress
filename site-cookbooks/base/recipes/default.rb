include_recipe "monit"
include_recipe "monit::ubuntu12fix"
include_recipe "monit::ssh"
include_recipe "ssmtp"
include_recipe "newrelic"

monitrc "sys" do
  template_cookbook "base"
end

swap_file '/mnt/swap' do
  size      2048    # MBs
  persist 	true
end

package 'htop'
package 'unzip'