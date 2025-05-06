#!/bin/bash

# Remove containerd.io
apt-get remove --auto-remove containerd.io

# Purge containerd.io
apt-get purge --auto-remove containerd.io

# Install containerd.io
apt-get install containerd.io

rm /etc/containerd/config.toml
containerd config default > /etc/containerd/config.toml

# Restart containerd
systemctl restart containerd