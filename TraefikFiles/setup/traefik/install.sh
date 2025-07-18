#!/bin/bash

# Create a volume for persistent data
mkdir -p ./traefik_data

# Pull the Traefik Docker image
docker pull traefik/traefik:latest

# Run the Traefik container with a volume mount
docker run -d \
  --name traefik \
  -p 80:80 \
  -v ./traefik_data:/data \
  traefik/traefik:latest
