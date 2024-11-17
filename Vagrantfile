Vagrant.configure("2") do |config|
  config.vm.define "nginx-fjmm" do |nginx|
    nginx.vm.box = "debian/bookworm64"
    nginx.vm.hostname = "nginx-fjmm"
    nginx.vm.network "private_network", ip: "192.168.57.102"
    nginx.vm.provision "shell", path: "provision.sh"
  end
end