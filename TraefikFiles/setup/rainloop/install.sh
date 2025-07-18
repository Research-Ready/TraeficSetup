#!/bin/bash

# Create a volume for persistent data
mkdir -p ./rainloop_data

# Pull the Rainloop Docker image
docker pull rainloop/rainloop:latest

# Run the Rainloop container with a volume mount
docker run -d \
  --name rainloop \
  -p 8080:80 \
  -v ./rainloop_data:/data \
  rainloop/rainloop:latest
