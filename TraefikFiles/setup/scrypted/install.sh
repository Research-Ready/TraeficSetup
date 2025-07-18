#!/bin/bash

# Create a volume for persistent data
mkdir -p ./scrypted_data

# Pull the Scrypted Docker image
docker pull scrypted/scrypted:latest

# Run the Scrypted container with a volume mount
docker run -d \
  --name scrypted \
  -p 4000:4000 \
  -v ./scrypted_data:/data \
  scrypted/scrypted:latest
