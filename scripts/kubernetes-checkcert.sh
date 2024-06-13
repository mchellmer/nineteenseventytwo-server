#!/bin/bash

# Install yq
sudo apt update
sudo apt install -y yq

# Run the command
echo "user certificate info:"
yq -r '.users[0].user."client-certificate-data"' < ~/.kube/config | base64 -d | openssl x509 -text

echo "cluster certificate info:"
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout

echo "cluster key info:"
openssl rsa -in /etc/kubernetes/pki/apiserver.key -check

echo "cluster certificate modulus ... check these match:"
echo "certificate:"
openssl x509 -noout -modulus -in /etc/kubernetes/pki/apiserver.crt | openssl md5
echo "key:"
openssl rsa -noout -modulus -in /etc/kubernetes/pki/apiserver.key | openssl md5