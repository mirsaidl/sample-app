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

# Create Dockerfile
cat <<EOF > tempdir/Dockerfile
FROM python
RUN pip install flask

COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/

EXPOSE 5050
CMD python3 /home/myapp/sample_app.py
EOF

# Navigate to tempdir
cd tempdir

# Build Docker image
docker build -t sampleapp-new-2 .

# Stop and remove any container using port 5050
EXISTING_PORT=$(docker ps --filter "publish=5050" -q)
if [ -n "$EXISTING_PORT" ]; then
  echo "Stopping container using port 5050..."
  docker stop $EXISTING_PORT
  docker rm $EXISTING_PORT
fi

# Stop and remove old container if exists
docker stop samplerunning-new 2>/dev/null || true
docker rm samplerunning-new 2>/dev/null || true

# Run container
docker run -t -d -p 5050:5050 --name samplerunning-new sampleapp-new-2

# Show running containers
docker ps -a
