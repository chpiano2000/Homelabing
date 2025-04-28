# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.provider "libvirt" do |libvirt|
    libvirt.memory = 4096
    libvirt.cpus = 2
  end

  config.vm.box = "generic/ubuntu2004"

  config.vm.define "controller" do |controller|
    controller.vm.hostname = "controller.k8s.com"
    controller.vm.network "private_network", ip: "192.168.56.11"
    controller.vm.provision "shell", path: "scripts/bootstrap.sh"
	  controller.vm.provision "shell", inline: <<-SHELL
	    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	    echo "nameserver 1.1.1.1" >> /etc/resolv.conf
      SHELL
    controller.vm.provision "shell", path: "scripts/bootstrap.sh"
  end

  config.vm.define "worker1" do |worker1|
    worker1.vm.hostname = "worker1.k8s.com"
    worker1.vm.network "private_network", ip: "192.168.56.12"
	  worker1.vm.provision "shell", inline: <<-SHELL
	    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	    echo "nameserver 1.1.1.1" >> /etc/resolv.conf
      SHELL
    worker1.vm.provision "shell", path: "scripts/bootstrap.sh"
  end

  config.vm.define "worker2" do |worker2|
    worker2.vm.hostname = "worker2.k8s.com"
    worker2.vm.network "private_network", ip: "192.168.56.13"
    worker2.vm.provision "shell", path: "scripts/bootstrap.sh"
	  worker2.vm.provision "shell", inline: <<-SHELL
	    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	    echo "nameserver 1.1.1.1" >> /etc/resolv.conf
      SHELL
    worker2.vm.provision "shell", path: "scripts/bootstrap.sh"
  end
end


