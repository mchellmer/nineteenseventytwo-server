#!/bin/bash

ansible-playbook k8s-netplan.yaml -e ansible_become_password=$1