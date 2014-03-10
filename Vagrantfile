# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "ubuntu13_04"
  # config.vm.box = "ubuntu13_10"
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network :forwarded_port, guest: 80, host: 8085

  VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

  config.omnibus.chef_version = "11.6.2"
  # server.omnibus.chef_version = "11.8.0"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"
    chef.provisioning_path = "/tmp/vagrant-chef"
    chef.log_level = :info

    # You may also specify custom JSON attributes:
    chef.run_list = VAGRANT_JSON.delete('run_list')
    chef.json = VAGRANT_JSON

    # Dir["#{Pathname(__FILE__).dirname.join('roles')}/*.json"].each do |role|
    #   chef.add_role(role)
    # end
  end

  config.vm.define :lovelycarte_vb do |server|
    server.vm.synced_folder "/Users/anthony/.ssh", "/root/.ssh",  owner: "root", group: "root"
    server.vm.hostname = 'lovelycarte.com'
  end

  config.vm.define :lovelycarte do |server|
    server.vm.hostname = 'lovelycarte.com'

    server.vm.provider :digital_ocean do |provider, override|
      server.ssh.forward_agent = false
      override.ssh.private_key_path = '~/.ssh/id_rsa'
      override.vm.box = 'digital_ocean'
      override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

      provider.client_id = ENV["DIGITAL_OCEAN_ID"]
      provider.api_key = ENV["DIGITAL_OCEAN_KEY"]
      provider.image = "Ubuntu 12.04.3 x64"
      provider.region = "Amsterdam 2"
      provider.size = "1GB"
      provider.backups_enabled = true
    end
  end

end
