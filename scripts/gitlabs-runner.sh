#!/bin/bash

# Prompt the user for the GitLab Runner token
read -p "Enter the GitLab Runner token: " TOKEN

# Add the GitLab Runner repository and install its package
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y

# Register the GitLab Runner - create it in GitLab first
sudo gitlab-runner register \
  --non-interactive \
  --executor "shell" \
  --url "http://gitlab.local/" \
  --token "$TOKEN"