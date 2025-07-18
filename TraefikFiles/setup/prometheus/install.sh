#!/bin/bash

# Create a volume for persistent data
mkdir -p ./prometheus_data

# Pull the Prometheus Docker image
docker pull prom/prometheus:latest

# Run the Prometheus container with a volume mount
docker run -d \
  --name prometheus \
  -p 9090:9090 \
  -v ./prometheus_data:/prometheus \
  prom/prometheus:latest
