#!/bin/bash

# Create a volume for persistent data
mkdir -p ./tablo_data

# Pull the Tablo Docker image
docker pull tablo/tablo:latest

# Run the Tablo container with a volume mount
docker run -d \
  --name tablo \
  -p 8889:8889 \
  -v ./tablo_data:/config \
  tablo/tablo:latest
