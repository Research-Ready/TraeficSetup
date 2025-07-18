#!/bin/bash

# Create a volume for persistent data
mkdir -p ./shelfie_data

# Pull the Shelfie Docker image
docker pull shelfie/shelfie:latest

# Run the Shelfie container with a volume mount
docker run -d \
  --name shelfie \
  -p 8080:80 \
  -v ./shelfie_data:/app/data \
  shelfie/shelfie:latest
