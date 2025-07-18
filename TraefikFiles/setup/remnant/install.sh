#!/bin/bash

# Create a volume for persistent data
mkdir -p ./remnant_data

# Pull the Remnant Docker image
docker pull remnant/remnant:latest

# Run the Remnant container with a volume mount
docker run -d \
  --name remnant \
  -p 8080:80 \
  -v ./remnant_data:/app/data \
  remnant/remnant:latest
