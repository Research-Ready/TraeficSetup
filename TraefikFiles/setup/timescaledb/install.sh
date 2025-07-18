#!/bin/bash

# Create a volume for persistent data
mkdir -p ./timescaledb_data

# Pull the TimescaleDB Docker image
docker pull timescale/timescaledb:latest

# Run the TimescaleDB container with a volume mount
docker run -d \
  --name timescaledb \
  -p 5432:5432 \
  -v ./timescaledb_data:/var/lib/postgresql/data \
  timescale/timescaledb:latest
