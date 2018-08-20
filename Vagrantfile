# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "dns_server" do |dns_server_config|
    dns_server_config.vm.box = "bento/centos-7.4"
    dns_server_config.vm.hostname = "dns.codingbee.net"
    # https://www.vagrantup.com/docs/virtualbox/networking.html
    dns_server_config.vm.network "private_network", ip: "192.170.10.100", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    dns_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_dns_server"
    end

    dns_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    dns_server_config.vm.provision "shell", path: "scripts/setup-caching-only-dns-server.sh", privileged: true
  end



  config.vm.define "dns_client" do |dns_client_config|
    dns_client_config.vm.box = "bento/centos-7.4"
    dns_client_config.vm.hostname = "dns-client.codingbee.net"
    dns_client_config.vm.network "private_network", ip: "192.170.10.101", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    dns_client_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_dns_client"
    end

    dns_client_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    dns_client_config.vm.provision "shell", path: "scripts/install-gnome-gui.sh", privileged: true
    dns_client_config.vm.provision "shell", path: "scripts/setup-dns-client.sh", privileged: true
  end

  # this line relates to the vagrant-hosts plugin, https://github.com/oscar-stack/vagrant-hosts
  # it adds entry to the /etc/hosts file. 
  # this block is placed outside the define blocks so that it gts applied to all VMs that are defined in this vagrantfile. 
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.170.10.100', ['dns.codingbee.net']  
    provisioner.add_host '192.170.10.101', ['dns_client.codingbee.net']
  end


end
