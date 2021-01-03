# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"

      # NOTE: (r2r-dev) aligned to my machine capabilities
      vb.cpus = "2"

      # https://github.com/hashicorp/vagrant/issues/11777#issuecomment-661076612
      vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
      vb.customize ["modifyvm", :id, "--uartmode1", "file", File::NULL]

      # NOTE: (r2r-dev) use host resolver to increase dl speeds
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.provision "shell", inline: <<-SHELL
      apt-get update && apt-get upgrade -y
      apt-get install -y curl docker.io snapd git golang python3 python3-pip
      systemctl enable docker
      systemctl start docker
      usermod -aG docker vagrant

      # Install kubectl
      curl -Lso /tmp/kubectl "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
      install -m 755 /tmp/kubectl /usr/local/bin

      # Install and start minikube
      curl -Lso /tmp/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
      install -m 755 /tmp/minikube /usr/local/bin/
      
      # NOTE: (r2r-dev) no need to statrt minikube just yet
      #sudo -u vagrant MINIKUBE_IN_STYLE=0 minikube start --driver=docker 2> /dev/null

      # Install Helm
      curl -s https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
 
      # NOTE: (r2r-dev)
      # Install argocd
      curl -Lso /tmp/argocd https://github.com/argoproj/argo-cd/releases/download/v1.8.1/argocd-linux-amd64
      install -m 755 /tmp/argocd /usr/local/bin

      # NOTE: (r2r-dev)
      # Copy contents of synced folder to internal disk to avoid absurdly long disk operations on loads of tiny files (think pip, docker cache, ccache, etc.).
      rsync -az --chown=vagrant:vagrant /syncd/ project
      
  SHELL
  config.vm.synced_folder ".", "/syncd" 
  # NOTE: (r2r-dev)  alternatively, if running on *nix system, one can use rsync synced folder, as stated below.
  #config.vm.synced_folder ".", "/syncd", type: "rsync"
  config.vm.boot_timeout = 600
end
