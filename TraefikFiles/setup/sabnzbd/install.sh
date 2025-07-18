#!/bin/bash

# Create a volume for persistent data
mkdir -p ./sabnzbd_data

# Pull the Sabnzbd Docker image
docker pull sabnzbd/sabnzbd:latest

# Run the Sabnzbd container with a volume mount
docker run -d \
  --name sabnzbd \
  -p 8080:80 \
  -v ./sabnzbd_data:/config \
  sabnzbd/sabnzbd:latest
