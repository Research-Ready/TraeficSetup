#!/bin/bash

# Create a volume for persistent data
mkdir -p ./uptimekuma_data

# Pull the UptimeKuma Docker image
docker pull uptimekuma/uptimekuma:latest

# Run the UptimeKuma container with a volume mount
docker run -d \
  --name uptimekuma \
  -p 3001:3001 \
  -v ./uptimekuma_data:/app/data \
  uptimekuma/uptimekuma:latest
