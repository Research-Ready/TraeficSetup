#!/bin/bash

# Create a volume for persistent data
mkdir -p ./openbb_data

# Pull the OpenBB Docker image
docker pull openbbfinance/openbb:latest

# Run the OpenBB container with a volume mount
docker run -d \
  --name openbb \
  -p 8000:8000 \
  -v ./openbb_data:/app/data \
  openbbfinance/openbb:latest
