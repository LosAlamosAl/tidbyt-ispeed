#!/bin/bash

# Load .env variables (TIDBYT_API_KEY, TIDBYT_DEVICE_ID, TIDBYT_INSTALL_ID)
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Render with the private URL
pixlet render ispeed.star data="$1"

# Push to Tidbyt
pixlet push --api-token "$TIDBYT_API_KEY" "$TIDBYT_DEVICE_ID" ispeed.webp --installation-id "$TIDBYT_INSTALL_ID" --background

# To delete from Tidbyt:
# pixlet delete "$TIDBYT_DEVICE_ID" "$TIDBYT_INSTALL_ID" --api-token "$TIDBYT_API_KEY" 
