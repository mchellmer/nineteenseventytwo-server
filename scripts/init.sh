apt update
apt upgrade -y
apt -y install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt -y install ansible