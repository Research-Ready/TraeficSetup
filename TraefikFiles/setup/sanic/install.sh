#!/bin/bash

# Create a volume for persistent data
mkdir -p ./sanic_data

# Pull the Sanic Docker image
docker pull sanic/sanic:latest

# Run the Sanic container with a volume mount
docker run -d \
  --name sanic \
  -p 8080:80 \
  -v ./sanic_data:/app/data \
  sanic/sanic:latest
