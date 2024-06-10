#!/bin/bash

# Install yq
sudo apt update
sudo apt install -y yq

# Run the command
yq -r '.users[0].user."client-certificate-data"' < ~/.kube/config | base64 -d | openssl x509 -text