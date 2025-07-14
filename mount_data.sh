#!/bin/bash

# Default to /mnt/data if no argument is passed
LOCAL_DIR=${1:-/mnt/data}
REMOTE_DIR="/mnt/data"

# Check if local directory exists
if [ ! -d "$LOCAL_DIR" ]; then
  echo "❌ Local directory does not exist: $LOCAL_DIR"
  exit 1
fi

# Show mount info
echo "🔧 Preparing to mount local directory:"
echo "  Local Path  : $LOCAL_DIR"
echo "  Minikube -> : $REMOTE_DIR"
echo

# Start the mount process
echo "🚀 Starting mount service..."
echo "📌 Use Ctrl+C to stop the mount"
minikube mount "${LOCAL_DIR}:${REMOTE_DIR}"
