# 1972-Server
iaas and kubernetes cluster config for 1972
The playbook installs isc-dhcp-server using the apt module.
The lineinfile module is used to update the 50-cloud-init.yaml file by changing dhcp4: true to dhcp4: false.
The template module is used to update the dhcpd.conf file. Ensure you have a template file (dhcpd.conf.j2) with the required configurations.
Handlers are defined to apply Netplan changes and restart the DHCP server when needed.

# Setup servers
1. Boot up - Boot of latest ubuntu (tested on 24.4) on rpi (tested on rpi3/4/5)
   - ubuntu on console - rpi3
   - raspbian lite on nodes - rpi5 master, rpi4 workers
   - set config via imager:
     - hostname - to match /group_vars/all/vars.yaml
     - wifi name and pass
     - region settings
     - user/pass
   - BEFORE BOOTING - setup cgroup in config and cmdline files on sd card
     - add cgroup_memory=1 cgroup_enable=memory to /cmdline.txt
     - add dtoverlay=vc4-kms-v3d,cma-256 to /config.txt
2. Get code - Git pull https://github.com/mchellmer/1972-Server.git
   - adjust /group_vars/all.yaml to match your network settings
     - boot into each pi or e.g. my router gui shows all pis with ip addresses and mac addresses for each
     - consider setting static ips via router or dhcp server
3. Init console
   - ```bash
     sudo apt update
     sudo apt install make
     make console-init
     ```
   - after reboot
     ```bash
     make ansible-console-init
     ```
   - after reboot
     ```bash
     make ansible-console-config
     ```
   - Updates/upgrades and install ansible/ansible vault on console host, generate secrets on server
   - install ansible and add secrets to vault
     - you will be prompted for the following so have them ready:
       - a vault password - save this in order to access the vault
         ```bash
         # The following command will generate a random 32 character password
         openssl rand -base64 32
         ```
       - the wifi hash from /etc/netplan/50-cloud-init.yaml.network.wifis.wlan0.access-points.<wifi name>.auth.password
       - an ansible become password - this is the password some user ansible will run as, in these scripts it's for 'mchellmer'
       - an ansible default ip address to setup egress to some ip
     - ```bash
       make ansible-vault-init
       ```
   - Networking
     - this disables automatic dhcp and sets static ip for console
     - it preserves the wifi settings as long as correct hash provided in step 3
   - Setup console via ansible
     - this sets the ansible host as a dhcp server serving ip addresses to nodes
     - configures ip tables for kubernetes traffic allowing bridge traffic between console and nodes
4. Config nodes
    - connect nodes to ethernet switch
    - turn on nodes similar to 1 
    - ensure node hostnames are correct (set when creating image) in /etc/hosts on console - ssh to debug
    - ```bash
      make nodes-init
      ```
      - updates/upgrades distro
      - one time connect via pass to generate and distribute ssh keys to nodes
      - configures ip tables similar to step 3 for console
5. Kubernetes and CNI
   - ```bash
     make deploy-kubernetes
     ```
     - Install docker disabling swap
     - Install kubernetes, CNI
     - Join nodes to cluster

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