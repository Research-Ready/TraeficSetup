#!/bin/bash

# Create a volume for persistent data
mkdir -p ./sonarr_data

# Pull the Sonarr Docker image
docker pull sonarr/sonarr:latest

# Run the Sonarr container with a volume mount
docker run -d \
  --name sonarr \
  -p 8920:8920 \
  -v ./sonarr_data:/config \
  sonarr/sonarr:latest
