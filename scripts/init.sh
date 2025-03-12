#!/bin/bash

apt update
apt upgrade -y
apt -y install software-properties-common sshpass

apt -y install ansible

git config --global user.email "mchellmer@gmail.com"
git config --global user.name "Mark Hellmer"

sed -i 's/^FONTSIZE=.*/FONTSIZE="16x32"/' /etc/default/console-setup

reboot now