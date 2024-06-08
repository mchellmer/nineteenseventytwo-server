#!/bin/bash

ansible-playbook k8s-netplan.yaml -e ENV_WIFI_PASSWORD=$1 -K