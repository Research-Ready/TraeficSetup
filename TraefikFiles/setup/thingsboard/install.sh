#!/bin/bash

# Create a volume for persistent data
mkdir -p ./thingsboard_data

# Pull the ThingsBoard Docker image
docker pull thingsboard/thingsboard:latest

# Run the ThingsBoard container with a volume mount
docker run -d \
  --name thingsboard \
  -p 8080:80 \
  -v ./thingsboard_data:/data \
  thingsboard/thingsboard:latest
