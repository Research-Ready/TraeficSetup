#!/bin/bash

# Create a volume for persistent data
mkdir -p ./terragrunt_data

# Pull the Terragrunt Docker image
docker pull terragrunt/terragrunt:latest

# Run the Terragrunt container with a volume mount
docker run -d \
  --name terragrunt \
  -p 8080:80 \
  -v ./terragrunt_data:/app/data \
  terragrunt/terragrunt:latest
