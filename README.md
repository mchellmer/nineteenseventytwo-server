# 1972-Server
iaas and kubernetes cluster config for 1972
The playbook installs isc-dhcp-server using the apt module.
The lineinfile module is used to update the 50-cloud-init.yaml file by changing dhcp4: true to dhcp4: false.
The template module is used to update the dhcpd.conf file. Ensure you have a template file (dhcpd.conf.j2) with the required configurations.
Handlers are defined to apply Netplan changes and restart the DHCP server when needed.

# Setup servers
1. Boot up - Boot of latest ubuntu (tested on 24.4) on rpi (tested on rpi4/5)
   - ubuntu on console
   - raspbian lite on nodes
   - set config via imager:
     - hostname
     - wifi name and pass
     - region settings
     - user/pass
   - BEFORE BOOTING - setup cgroup in config and cmdline files on sd card
     - add cgroup_memory=1 cgroup_enable=memory to /cmdline.txt
     - add dtoverlay=vc4-kms-v3d,cma-256 to /config.txt
2. Get code - Git pull https://github.com/mchellmer/1972-Server.git
3. Init console
   - Updates/upgrades and install ansible/ansible vault on console host, generate secrets on server
   - Make /scripts/init.sh executable
   - install ansible and add secrets to vault
     - Make /scripts/ansible-vault-init.sh executable and run
       - you will be prompted for:
         - a vault password - save this in order to access the vault
         - the wifi hash from /etc/netplan/50-cloud-init.yaml.network.wifis.wlan0.access-points.<wifi name>.auth.password
         - an ansible become password - this is the password for some user ansible will run as, in these scripts it's for 'mchellmer'
         - an ansible default ip address to setup egress to some ip
4. Get Connected - Run ansible-playbook k8s-netplan.yaml
   - this disables automatic dhcp and sets static ip for console
   - it preserves the wifi settings as long as correct hash provided in step 3
5. Setup console via ansible - Run ansible-playbook k8s-console.yaml
   - this sets the ansible host as a dhcp server serving ip addresses to nodes
   - configures ip tables for kubernetes traffic allowing bridge traffic between console and nodes
6. Config nodes
    - connect nodes to ethernet switch
    - turn on nodes similar to 1 
    - ensure node hostnames are correct (set when creating image) in /etc/hosts on console - ssh to debug
    - run ansible-playbook k8s-nodes.yaml --ask-pass (use ansible_user password)
      - update/upgrade distro
      - one time connect via pass to generate and distriute ssh keys to nodes
      - configures ip tables similar to step 5 for console
7. Install docker - run ansible-playbook k8s-docker.yaml
8. Install kubernetes - run ansible-playbook k8s-kubernetes.yaml
9. Install CNI Flannel - run ansible-playbook k8s-flannel.yaml
   - handles pod networking e.g. providing ip addresses to pods
   - deploys daemonset to nodes to form overlay network

# Troubleshoot
Nodes cannot connect to internet
- check status of isc-dhcp-server, restart service

Nodes not taking an ip from dhcp server
- for some reason when rp3 is the dhcp server and the nodes are ubuntu they are not getting ips -> switched to raspbian lite on nodes

Ansible complaingint about host identity change:
- remove the key and retry - probably some change in your hosts during init: `ssh-keygen -f '/home/mchellmer/.ssh/known_hosts' -R '1972-master-1'`

Kubectl connection refused
- ensure config exists
- ensure swapoff
- ensure kubelet is running
- ensure containerd config updated and service running
- ensure cgroup set to systemd in containerd config

Apt update fails to find kubernetes sources
- rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg and retry