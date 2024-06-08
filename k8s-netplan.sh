#!/bin/bash
read -p "Enter WiFi password: " wifi_password
ansible-playbook k8s-netplan.yaml -e ENV_WIFI_PASSWORD=$wifi_password -K