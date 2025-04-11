#!/bin/bash

# Check if the token is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <gitlab-runner-token>"
  exit 1
fi

TOKEN=$1

# Add the GitLab Runner repository and install its package
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y

# Register the GitLab Runner - create it in GitLab first
sudo gitlab-runner register \
  --non-interactive \
  --executor "shell" \
  --url "http://gitlab.local/" \
  --token "$TOKEN"