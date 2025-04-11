#!/bin/bash

# Add the GitLab Runner repository and install its package
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner -y

# Register the GitLab Runner
sudo gitlab-runner register