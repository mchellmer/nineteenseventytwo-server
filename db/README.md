# CouchDB Deployment Resources

This folder contains resources for building, deploying, and managing a CouchDB instance in a Kubernetes environment. It includes a Dockerfile for creating a CouchDB container image, Kubernetes manifests for deployment, and a GitHub Actions workflow for automating the build and deployment process.

## Overview

The resources in this folder are designed to:
1. Build a CouchDB Docker image.
2. Deploy the CouchDB container to a Kubernetes cluster using the provided manifests.
3. Automate the build and deployment process using a GitHub Actions workflow.

## Repository Structure

- **`Dockerfile`**: Defines the steps to build a CouchDB container image.
- **`k8s/`**: Contains Kubernetes manifests for deploying CouchDB:
  - `deployment.yaml`: Defines the CouchDB deployment.
  - `service.yaml`: Exposes the CouchDB deployment as a service within the cluster.
- **`.github/workflows/db-release.yaml`**: A GitHub Actions workflow to automate the build, push, and deployment process.

## Prerequisites

Before using these resources, ensure the following:
- Docker is installed and configured on your local machine or runner.
- Kubernetes is installed and configured, with access to the target cluster.
- The following secrets are configured in the GitHub repository settings:
  - `GITHUB_TOKEN`: Automatically provided by GitHub for authenticating with the GitHub Container Registry (GHCR).

## Usage

### Building and Pushing the Docker Image
1. Build the CouchDB Docker image:
   ```bash
   docker build -t ghcr.io/<repository_owner>/couchdb:latest .