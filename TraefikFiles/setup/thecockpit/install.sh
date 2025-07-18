#!/bin/bash

# Create a volume for persistent data
mkdir -p ./thecockpit_data

# Pull the TheCockpit Docker image
docker pull thecockpit/thecockpit:latest

# Run the TheCockpit container with a volume mount
docker run -d \
  --name thecockpit \
  -p 9090:9090 \
  -v ./thecockpit_data:/config \
  thecockpit/thecockpit:latest
