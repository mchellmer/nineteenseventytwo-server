# 1972-Server
iaas and kubernetes cluster config for 1972
The playbook installs isc-dhcp-server using the apt module.
The lineinfile module is used to update the 50-cloud-init.yaml file by changing dhcp4: true to dhcp4: false.
The template module is used to update the dhcpd.conf file. Ensure you have a template file (dhcpd.conf.j2) with the required configurations.
Handlers are defined to apply Netplan changes and restart the DHCP server when needed.

# Setup servers
1. Boot up - Boot of latest ubuntu (tested on 24.4) on rpi (tested on rpi4)
2. Get code - Git pull https://github.com/mchellmer/1972-Server.git
3. Update/upgrade and install ansible - Make /scripts/init.sh executable and run
4. Get Connected - Run k8s-netplan.sh <wifipassword>
5. Setup master node - Run k8s-master.sh
6. Boot nodes - turn on nodes similar to 1
7. Config nodes - ssh to nodes i.e. ssh user@node-1 etc (node-# host setup in part 5)
    - update /etc/hostname to node-# etc and exit ssh
    - run k8s-nodes.sh