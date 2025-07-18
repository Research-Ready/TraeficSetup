#!/bin/bash

# Create a volume for persistent data
mkdir -p ./syncthing_data

# Pull the Syncthing Docker image
docker pull syncthing/syncthing:latest

# Run the Syncthing container with a volume mount
docker run -d \
  --name syncthing \
  -p 8384:8384 \
  -v ./syncthing_data:/config \
  syncthing/syncthing:latest
