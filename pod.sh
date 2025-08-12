#!/bin/bash

case "$1" in
  --setup)
    echo "Creating PanoSETI Pod..."
    podman play kube panoseti-pod.yaml
    echo "Done."
    ;;
  --restart)
    echo "Checking Pod status..."
    podman pod ps
    echo "Done."
    ;;
  --restart)
    echo "Restarting PanoSETI Pod..."
    podman pod restart panoseti-pod
    echo "Done."
    ;;
  --stop)
    echo "Stopping PanoSETI Pod..."
    podman pod stop panoseti-pod
    echo "Done."
    ;;
  --del)
    echo "Deleting PanoSETI pod..."
    podman pod stop panoseti-pod
    podman pod rm panoseti-pod
    echo "Done."
    ;;
  *)
    echo "Usage: $0 {--setup|--status|--restart|--stop|--del}"
    exit 1
    ;;
esac