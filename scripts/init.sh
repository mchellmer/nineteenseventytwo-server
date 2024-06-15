apt update
apt upgrade -y
apt -y install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt -y install ansible

git config --global user.email "mchellmer@gmail.com"
git config --global user.name "Mark Hellmer"

sed -i 's/^FONTSIZE=.*/FONTSIZE="16x32"/' /etc/default/console-setup
sed -i 's/^XKBLAYOUT=.*/XKBLAYOUT="gb"/' /etc/default/keyboard
reboot now