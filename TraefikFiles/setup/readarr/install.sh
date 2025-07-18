#!/bin/bash

# Create a volume for persistent data
mkdir -p ./readarr_data

# Pull the Readarr Docker image
docker pull readarr/readarr:latest

# Run the Readarr container with a volume mount
docker run -d \
  --name readarr \
  -p 8787:8787 \
  -v ./readarr_data:/config \
  readarr/readarr:latest
