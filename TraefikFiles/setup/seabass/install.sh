#!/bin/bash

# Create a volume for persistent data
mkdir -p ./seabass_data

# Pull the Seabass Docker image
docker pull seabass/seabass:latest

# Run the Seabass container with a volume mount
docker run -d \
  --name seabass \
  -p 8080:80 \
  -v ./seabass_data:/app/data \
  seabass/seabass:latest
