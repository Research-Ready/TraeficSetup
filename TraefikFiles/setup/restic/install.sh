#!/bin/bash

# Create a volume for persistent data
mkdir -p ./restic_data

# Pull the Restic Docker image
docker pull restic/restic:latest

# Run the Restic container with a volume mount
docker run -d \
  --name restic \
  -p 8080:80 \
  -v ./restic_data:/backup \
  restic/restic:latest
