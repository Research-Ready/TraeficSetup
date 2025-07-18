#!/bin/bash

# Create a volume for persistent data
mkdir -p ./tiddlywiki_data

# Pull the TiddlyWiki Docker image
docker pull tiddlywiki/tiddlywiki:latest

# Run the TiddlyWiki container with a volume mount
docker run -d \
  --name tiddlywiki \
  -p 8080:80 \
  -v ./tiddlywiki_data:/data \
  tiddlywiki/tiddlywiki:latest
