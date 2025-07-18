#!/bin/bash

# Create a volume for persistent data
mkdir -p ./radarr_data

# Pull the Radarr Docker image
docker pull radarr/radarr:latest

# Run the Radarr container with a volume mount
docker run -d \
  --name radarr \
  -p 7878:7878 \
  -v ./radarr_data:/config \
  radarr/radarr:latest
