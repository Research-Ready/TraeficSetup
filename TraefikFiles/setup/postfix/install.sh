#!/bin/bash

# Create a volume for persistent data
mkdir -p ./postfix_data

# Pull the Postfix Docker image
docker pull postfix/postfix:latest

# Run the Postfix container with a volume mount
docker run -d \
  --name postfix \
  -p 25:25 \
  -v ./postfix_data:/var/lib/postfix \
  postfix/postfix:latest
