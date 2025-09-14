Vagrant.configure("2") do |config|
  config.vm.box = "gusztavvargadr/windows-server-2019-standard-core"

  # Define multiple Windows VMs
  ["winserver1", "winserver2", "winserver3"].each_with_index do |name, i|
    config.vm.define name do |node|
      node.vm.hostname = name
      node.vm.network "private_network", ip: "192.168.56.#{10 + i}"

      # Bootstrap DSC modules first
      node.vm.provision "shell", path: "roles/windows/bootstrap.ps1"

      # Apply DSC configuration
      node.vm.provision "shell", path: "roles/windows/dsc.ps1"
    end
  end
end


# Vagrant.configure("2") do |config|
#   config.vm.define "linux1" do |linux|
#     linux.vm.box = "ubuntu/jammy64"
#     linux.vm.hostname = "linux1"

#     linux.vm.provider "virtualbox" do |vb|
#       vb.memory = 1024
#       vb.cpus = 1
#     end

#     linux.vm.provision "shell", path: "roles/linux/provision.sh"
#   end

#   config.vm.define "winserver1" do |win|
#     win.vm.box = "gusztavvargadr/windows-server-2019-standard-core"
#     win.vm.hostname = "winserver1"

#     win.vm.provider "virtualbox" do |vb|
#       vb.gui = true
#       vb.memory = 4096
#       vb.cpus = 2
#     end

#     win.vm.communicator = "winrm"
#     win.vm.network "forwarded_port", guest: 5985, host: 55985, id: "winrm", auto_correct: true

#     win.winrm.username = "vagrant"
#     win.winrm.password = "vagrant"

#     # win.vm.provision "shell", path: "roles/windows/provision.ps1"
#     win.vm.provision "shell", path: "roles/windows/bootstrap.ps1"
#     win.vm.provision "shell", path: "roles/windows/dsc.ps1"
#   end
# end
