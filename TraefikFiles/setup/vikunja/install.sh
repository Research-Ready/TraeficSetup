#!/bin/bash

# Create a volume for persistent data
mkdir -p ./vikunja_data

# Pull the Vikunja Docker image
docker pull vikunja/vikunja:latest

# Run the Vikunja container with a volume mount
docker run -d \
  --name vikunja \
  -p 3456:3456 \
  -v ./vikunja_data:/data \
  vikunja/vikunja:latest
