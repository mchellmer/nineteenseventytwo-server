#!/bin/bash

# This script updates and upgrades the system, installs necessary packages,
# and optionally installs Ansible if the -a flag is provided.
#
# Usage:
#   ./init.sh [-a]
#
# Options:
#   -a    Install Ansible

# Check if the user wants to install Ansible
INSTALL_ANSIBLE=false
while getopts "a" opt; do
  case ${opt} in
    a )
      INSTALL_ANSIBLE=true
      ;;
    \? )
      echo "Usage: cmd [-a]"
      exit 1
      ;;
  esac
done

apt update
apt upgrade -y
apt -y install software-properties-common

if [ "$INSTALL_ANSIBLE" = true ]; then
  add-apt-repository --yes --update ppa:ansible/ansible
  apt -y install ansible
fi

git config --global user.email "mchellmer@gmail.com"
git config --global user.name "Mark Hellmer"

sed -i 's/^FONTSIZE=.*/FONTSIZE="16x32"/' /etc/default/console-setup
#sed -i 's/^XKBLAYOUT=.*/XKBLAYOUT="gb"/' /etc/default/keyboard
reboot now