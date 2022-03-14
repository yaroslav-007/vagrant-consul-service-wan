Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    ip_server1= "192.168.56.4"
    ip_server2= "192.168.56.5"
    dc1="dc1"
    dc2="dc2"

    config.vm.define "server1" do |server1|
      server1.vm.provision "shell", path: "script/install-server.sh", privileged: true, args: [ip_server1, ip_server2, dc1]
      server1.vm.network "private_network", ip: "192.168.56.4"
      server1.vm.network "forwarded_port", guest: 8500, host: 9000
      server1.vm.hostname = "server1"
    end

    config.vm.define "server2" do |server2|
      server2.vm.provision "shell", path: "script/install-server.sh", privileged: true, args: [ip_server2, ip_server1, dc2]
      server2.vm.network "private_network", ip: "192.168.56.5"
      server2.vm.network "forwarded_port", guest: 8500, host: 9001
      server2.vm.hostname = "server2"

    end

  end