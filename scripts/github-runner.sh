#!/bin/bash

# Variables
RUNNER_VERSION="2.323.0"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_FOLDER="actions-runner"
REPO_URL="https://github.com/mchellmer/nineteenseventytwo-server"

# Prompt the user for the GitHub Actions Runner token
read -p "Enter the GitHub Actions Runner token: " TOKEN

# Create a folder for the runner
echo "Creating folder for GitHub Actions Runner..."
mkdir -p $RUNNER_FOLDER && cd $RUNNER_FOLDER

# Download the latest runner package
echo "Downloading GitHub Actions Runner version $RUNNER_VERSION..."
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L $RUNNER_URL

# Optional: Validate the hash
echo "Validating the hash..."
echo "0dbc9bf5a58620fc52cb6cc0448abcca964a8d74b5f39773b7afcad9ab691e19  actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c

# Extract the installer
echo "Extracting the runner package..."
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Configure the runner
echo "Configuring the GitHub Actions Runner..."
./config.sh --url $REPO_URL --token $TOKEN

# Run the runner
echo "Starting the GitHub Actions Runner..."
./run.sh