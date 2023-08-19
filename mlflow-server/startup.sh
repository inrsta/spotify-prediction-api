#!/bin/bash

# Update and install required packages
sudo apt update
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
sudo apt install python3 -y
sudo apt install python3-pip -y

# Install Python libraries using pip3
pip3 install mlflow google-cloud-storage

# Generalize the PATH update for the current user
export PATH=$PATH:/home/$(whoami)/.local/bin

ARTIFACT_ROOT=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/ARTIFACT_ROOT)
export ARTIFACT_ROOT

# Start the MLflow server with a general artifact root (Consider changing this as per requirement)
# If you want users to specify their own bucket, you can have them set an environment variable or modify this script.
   # Just an example, customize as needed
mlflow server --app-name basic-auth --host 0.0.0.0 --default-artifact-root $ARTIFACT_ROOT
