#!/bin/bash

# Determine active environment
if [ -f /home/ubuntu/current_color.txt ]; then
  CURRENT_COLOR=$(cat /home/ubuntu/current_color.txt)
else
  CURRENT_COLOR=green
fi

if [ "$CURRENT_COLOR" = "blue" ]; then
  TARGET_COLOR=green
  TARGET_PORT=8081
else
  TARGET_COLOR=blue
  TARGET_PORT=8080
fi

# Clean up existing container
docker stop $TARGET_COLOR || true
docker rm $TARGET_COLOR || true

# Build new Docker image
docker build -t $TARGET_COLOR /home/ubuntu/blue-green-deploy

# Run new container on selected port
docker run -d \
  --name $TARGET_COLOR \
  -p $TARGET_PORT:80 \
  $TARGET_COLOR

# Record new active environment
echo "$TARGET_COLOR" > /home/ubuntu/current_color.txt
echo "✅ Successfully deployed to $TARGET_COLOR on port $TARGET_PORT"
