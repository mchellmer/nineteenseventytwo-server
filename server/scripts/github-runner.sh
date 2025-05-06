#!/bin/bash

# Variables
RUNNER_VERSION="2.323.0"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz"
RUNNER_FOLDER="$HOME/actions-runner"
REPO_URL="https://github.com/mchellmer/nineteenseventytwo-server"
HASH="9cb778fffd4c6d8bd74bc4110df7cb8c0122eb62fda30b389318b265d3ade538"

# Install prerequisites
echo "Installing prerequisites..."
sudo apt update
sudo apt install libicu-dev libssl-dev libcurl4-openssl-dev -y

# Prompt the user for the GitHub Actions Runner token
read -p "Enter the GitHub Actions Runner token: " TOKEN

# Create a folder for the runner
echo "Creating folder for GitHub Actions Runner in $RUNNER_FOLDER..."
mkdir -p $RUNNER_FOLDER && cd $RUNNER_FOLDER

# Download the latest runner package
echo "Downloading GitHub Actions Runner version $RUNNER_VERSION..."
curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L $RUNNER_URL

# Optional: Validate the hash
echo "Validating the hash..."
echo "${HASH}  actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c

# Extract the installer
echo "Extracting the runner package..."
tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# Configure the runner
echo "Configuring the GitHub Actions Runner..."
./config.sh --url $REPO_URL --token $TOKEN

# Set up as a systemd service
echo "Setting up the GitHub Actions Runner as a systemd service..."
sudo ./svc.sh install

# Enable the service to start on boot
echo "Enabling the GitHub Actions Runner service..."
sudo systemctl enable actions.runner.mchellmer-nineteenseventytwo-server.1972-console-1.service

# Start the service
echo "Starting the GitHub Actions Runner service..."
sudo systemctl start actions.runner.mchellmer-nineteenseventytwo-server.1972-console-1.service