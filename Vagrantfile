# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



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
    dns_client_config.vm.hostname = "dns_client.codingbee.net"
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
