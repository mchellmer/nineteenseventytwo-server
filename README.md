# 1972-Server
iaas and kubernetes cluster config for 1972
The playbook installs isc-dhcp-server using the apt module.
The lineinfile module is used to update the 50-cloud-init.yaml file by changing dhcp4: true to dhcp4: false.
The template module is used to update the dhcpd.conf file. Ensure you have a template file (dhcpd.conf.j2) with the required configurations.
Handlers are defined to apply Netplan changes and restart the DHCP server when needed.

# Setup servers
1. Boot up - Boot of latest ubuntu (tested on 24.4) on rpi (tested on rpi4/5)
2. Get code - Git pull https://github.com/mchellmer/1972-Server.git
3. Update/upgrade and install ansible/ansible vault, generate secrets on server
    - Make /scripts/init.sh executable and run
    - Make /scripts/ansible-vault-init.sh and run
4. Get Connected - Run ansible-playbook k8s-netplan.yaml
5. Setup master node - Run ansible-playbook k8s-master.yaml
6. Config nodes
    - connect master and nodes to ethernet switch
    - turn on nodes similar to 1 
    - ssh to nodes i.e. ssh user@node-1 etc (node-# host setup in part 5)
    - update /etc/hostname to node-# etc and exit ssh
    - run ansible-playbook k8s-nodes.yaml --ask-pass (use ansible_user password)
7. Install docker - Run ansible-playbook k8s-docker.yaml
8. Install kubernetes and link nodes - Run ansible-playbook k8s-kubernetes.yaml
9. Add cillium - Run ansible-playbook k8s-cillium.yaml
   - note that cillium replaced flannel to add loadbalancing and network policies

# Troubleshoot
Nodes cannot connect to internet
- check status of isc-dhcp-server, restart service

Kubectl connection refused
- ensure config exists
- ensure swapoff
- ensure kubelet is running
- ensure containerd config updated and service running
- ensure cgroup set to systemd in containerd config

Apt update fails to find kubernetes sources
- rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg and retry