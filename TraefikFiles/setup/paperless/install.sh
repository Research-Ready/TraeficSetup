#!/bin/bash

# Create a volume for persistent data
mkdir -p ./paperless_data

# Pull the Paperless Docker image
docker pull paperlessngx/paperless-ngx:latest

# Run the Paperless container with a volume mount
docker run -d \
  --name paperless \
  -p 8080:8080 \
  -v ./paperless_data:/opt/paperless/data \
  paperlessngx/paperless-ngx:latest
