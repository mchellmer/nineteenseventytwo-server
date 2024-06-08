#!/bin/bash

ansible-playbook k8s-netplan.yaml -e ansible_become_password=$1 -e ENV_WIFI_PASSWORD=$1