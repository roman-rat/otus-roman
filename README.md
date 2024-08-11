#Vagrant
Vagrant.configure("2") do |config|
  config.vm.box = "generic/centos9s" 

  config.vm.provider "virtualbox" do |vb|
    vb.name = "Cent9CLI" 
    vb.cpus = 2
    vb.memory = 4096
    vb.customize ["createhd", "--filename", "D:/VM-Vbox/Cent9CLI.vdi", "--size", 25600] 

  end

  config.vm.provision "shell", inline: <<-SHELL
    useradd roman
    echo "roman:17896520" | chpasswd
    usermod -aG wheel roman

    dnf update -y

    dnf install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm

    dnf --enablerepo=elrepo-kernel install -y kernel-ml

    grub2-set-default 2 
    grub2-mkconfig -o /boot/grub2/grub.cfg
    shutdown -r now
  SHELL

end
