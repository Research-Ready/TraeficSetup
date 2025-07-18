#!/bin/bash

# Create a volume for persistent data
mkdir -p ./photoprism_data

# Pull the Photoprism Docker image
docker pull photoprism/photoprism:latest

# Run the Photoprism container with a volume mount
docker run -d \
  --name photoprism \
  -p 8080:8080 \
  -v ./photoprism_data:/data \
  photoprism/photoprism:latest
