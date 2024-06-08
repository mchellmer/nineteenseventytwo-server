#!/bin/bash

ansible-playbook k8s-master.yaml -e "ENV_WIFI_PASSWORD=$1" -e ansible_be_user=$2 -e ansible_be_password=$3