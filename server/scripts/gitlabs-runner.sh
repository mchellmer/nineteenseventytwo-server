#!/bin/bash

# Get the eth0 IP address
ETH0_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Check if gitlab.local already exists in /etc/hosts
if ! grep -q "gitlab.local" /etc/hosts; then
  echo "Adding gitlab.local to /etc/hosts with IP $ETH0_IP"
  echo "$ETH0_IP gitlab.local" | sudo tee -a /etc/hosts > /dev/null
else
  echo "gitlab.local already exists in /etc/hosts"
fi

# Prompt the user for the GitLab Runner token
read -p "Enter the GitLab Runner token: " TOKEN

# Add the GitLab Runner repository and install its package
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y

# Register the GitLab Runner - create it in GitLab first
sudo gitlab-runner register \
  --non-interactive \
  --executor "shell" \
  --url "https://gitlab.com" \
  --token "$TOKEN"