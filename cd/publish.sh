#! /bin/bash
set -eou pipefail

BUILD_DIR="$(pwd)/build"
PLACE_FILE="${BUILD_DIR}/placefile.rbxl"

if [ ! -d "${BUILD_DIR}" ]; then
  mkdir -p "${BUILD_DIR}";
fi


echo "Building place..."
rojo build -o $PLACE_FILE

echo "Publishing ${PLACE_FILE} to universe '${UNIVERSE_ID}' / place '${PLACE_ID}'"
response="$(curl -s --location POST https://apis.roblox.com/universes/v1/$UNIVERSE_ID/places/$PLACE_ID/versions?versionType=Published \
    --header 'x-api-key: '$RBX_API_KEY \
    --header 'Content-Type: application/octet-stream' \
    --data-binary @${PLACE_FILE})"

version_number="$(echo $response | jq .versionNumber)"

if [ "${version_number}" = "null" ]; then
    echo "Failed to publish place ${response}"
    exit 1
fi

echo "Place version: ${version_number}"

