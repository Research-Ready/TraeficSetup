#!/bin/bash

# Create a volume for persistent data
mkdir -p ./outline_data

# Pull the Outline Docker image
docker pull outline/outline:latest

# Run the Outline container with a volume mount
docker run -d \
  --name outline \
  -p 80:80 \
  -v ./outline_data:/data \
  outline/outline:latest
