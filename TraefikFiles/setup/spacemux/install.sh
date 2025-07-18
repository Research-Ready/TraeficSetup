#!/bin/bash

# Create a volume for persistent data
mkdir -p ./spacemux_data

# Pull the Spacemux Docker image
docker pull spacemux/spacemux:latest

# Run the Spacemux container with a volume mount
docker run -d \
  --name spacemux \
  -p 8080:80 \
  -v ./spacemux_data:/app/data \
  spacemux/spacemux:latest
