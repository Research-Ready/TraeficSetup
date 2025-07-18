#!/bin/bash

# Create a volume for persistent data
mkdir -p ./teamcity_data

# Pull the TeamCity Docker image
docker pull jetbrains/teamcity-server:latest

# Run the TeamCity container with a volume mount
docker run -d \
  --name teamcity \
  -p 8111:8111 \
  -v ./teamcity_data:/data/teamcity_server/datadir \
  jetbrains/teamcity-server:latest
