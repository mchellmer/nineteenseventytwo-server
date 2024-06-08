#!/bin/bash

ansible-playbook k8s-nodes.yaml -K -e ansible_user=mchellmer -vvvv