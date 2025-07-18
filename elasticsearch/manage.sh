#!/bin/bash

set -e

RELEASE_NAME="my-elasticsearch"
CHART_PATH="./elasticsearch"

# User-defined Azure Blob Storage values
AzureBlobStorageName="na"
AzureBlobStorageContainerName="na"
AzureBlobStorageConnectionstring="na"

usage() {
  echo "Usage: $0 {install|upgrade|clean}"
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  install)
    helm install "$RELEASE_NAME" "$CHART_PATH" \
      --set "AzureBlobStorageName=$AzureBlobStorageName" \
      --set "AzureBlobStorageContainerName=$AzureBlobStorageContainerName" \
      --set "AzureBlobStorageConnectionstring=$AzureBlobStorageConnectionstring"
    ;;
  upgrade)
    helm upgrade --install "$RELEASE_NAME" "$CHART_PATH" \
      --set "AzureBlobStorageName=$AzureBlobStorageName" \
      --set "AzureBlobStorageContainerName=$AzureBlobStorageContainerName" \
      --set "AzureBlobStorageConnectionstring=$AzureBlobStorageConnectionstring"
    ;;
  clean)
    helm uninstall "$RELEASE_NAME"
    ;;
  *)
    usage
    ;;
esac 