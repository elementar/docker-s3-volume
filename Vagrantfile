Vagrant.configure('2') do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  config.vm.provision :shell, inline: <<SCRIPT
    apt-get update
    apt-get -y install docker.io
    ln -sf /usr/bin/docker.io /usr/local/bin/docker
    chmod 777 /var/run/docker.sock
    sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
SCRIPT


  # for speeds
  config.vm.network :private_network, ip: "192.168.50.9"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end
