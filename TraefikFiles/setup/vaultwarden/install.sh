#!/bin/bash

# Create a volume for persistent data
mkdir -p ./vaultwarden_data

# Pull the Vaultwarden Docker image
docker pull vaultwarden/server:latest

# Run the Vaultwarden container with a volume mount
docker run -d \
  --name vaultwarden \
  -p 8080:80 \
  -v ./vaultwarden_data:/data \
  vaultwarden/server:latest
