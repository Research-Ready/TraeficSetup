#!/bin/bash

# Create a volume for persistent data
mkdir -p ./stashbox_data

# Pull the Stashbox Docker image
docker pull stashbox/stashbox:latest

# Run the Stashbox container with a volume mount
docker run -d \
  --name stashbox \
  -p 8080:80 \
  -v ./stashbox_data:/app/data \
  stashbox/stashbox:latest
