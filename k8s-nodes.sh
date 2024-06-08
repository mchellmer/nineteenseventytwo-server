#!/bin/bash

ansible-playbook k8s-nodes.yaml -e ansible_become_password=$1