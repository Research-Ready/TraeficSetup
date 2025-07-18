#!/bin/bash

# Create a volume for persistent data
mkdir -p ./runescape_data

# Pull the RuneScape Docker image
docker pull runescape/runescape:latest

# Run the RuneScape container with a volume mount
docker run -d \
  --name runescape \
  -p 8080:80 \
  -v ./runescape_data:/app/data \
  runescape/runescape:latest
