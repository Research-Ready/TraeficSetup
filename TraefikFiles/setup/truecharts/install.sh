#!/bin/bash

# Create a volume for persistent data
mkdir -p ./truecharts_data

# Pull the TrueCharts Docker image
docker pull truecharts/truecharts:latest

# Run the TrueCharts container with a volume mount
docker run -d \
  --name truecharts \
  -p 8080:80 \
  -v ./truecharts_data:/data \
  truecharts/truecharts:latest
