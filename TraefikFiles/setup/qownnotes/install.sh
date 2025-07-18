#!/bin/bash

# Create a volume for persistent data
mkdir -p ./qownnotes_data

# Pull the QownNotes Docker image
docker pull qownnotes/qownnotes:latest

# Run the QownNotes container with a volume mount
docker run -d \
  --name qownnotes \
  -p 8080:80 \
  -v ./qownnotes_data:/data \
  qownnotes/qownnotes:latest
