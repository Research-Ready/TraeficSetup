#!/bin/bash

# Create a volume for persistent data
mkdir -p ./rocketchat_data

# Pull the Rocket.Chat Docker image
docker pull rocketchat/rocket:latest

# Run the Rocket.Chat container with a volume mount
docker run -d \
  --name rocketchat \
  -p 3000:3000 \
  -v ./rocketchat_data:/data \
  rocketchat/rocket:latest
