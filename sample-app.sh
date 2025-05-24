#!/bin/bash

# Clean up previous tempdir if it exists
rm -rf tempdir

# Create necessary directories
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Copy project files into tempdir
cp sample_app.py tempdir/
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/
cp Dockerfile tempdir/

# Navigate to tempdir
cd tempdir

# Build Docker image
docker build -t weather-app .

# Stop and remove any container using port 5050
EXISTING_PORT=$(docker ps --filter "publish=5050" -q)
if [ -n "$EXISTING_PORT" ]; then
    echo "Stopping container using port 5050..."
    docker stop $EXISTING_PORT
    docker rm $EXISTING_PORT
fi

# Stop and remove old container if exists
docker stop weather-app-container 2>/dev/null || true
docker rm weather-app-container 2>/dev/null || true

# Run container
docker run -d \
    --name weather-app-container \
    -p 5050:5050 \
    -e WEATHER_API_KEY=${WEATHER_API_KEY:-da7de5db55d2ecdb6209c17c812f34f0} \
    weather-app

# Show running containers
docker ps -a
