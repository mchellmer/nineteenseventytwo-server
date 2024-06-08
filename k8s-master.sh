#!/bin/bash

ansible-playbook k8s-master.yaml -e ansible_become_password=$1