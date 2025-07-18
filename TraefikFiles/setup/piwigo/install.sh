#!/bin/bash

# Create a volume for persistent data
mkdir -p ./piwigo_data

# Pull the Piwigo Docker image
docker pull piwigo/piwigo:latest

# Run the Piwigo container with a volume mount
docker run -d \
  --name piwigo \
  -p 8080:80 \
  -v ./piwigo_data:/var/www/html/upload \
  piwigo/piwigo:latest
