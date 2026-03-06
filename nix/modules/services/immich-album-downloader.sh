#!/bin/bash

# Immich Album Downloader
# Downloads all images from an Immich album with local/remote fallback
#
# Required environment variables:
#   IMMICH_LOCAL_URL    - Local Immich instance URL (e.g., http://192.168.1.100:2283)
#   IMMICH_REMOTE_URL   - Remote Immich instance URL (e.g., https://immich.example.com)
#   IMMICH_ALBUM_ID     - Album ID to download
#   IMMICH_API_KEY - API key for authentication
#   DOWNLOAD_DIR        - Directory to save images

set -euo pipefail

# Check required environment variables
if [[ -z "${IMMICH_LOCAL_URL:-}" ]]; then
    echo "Error: IMMICH_LOCAL_URL environment variable is not set"
    exit 1
fi

if [[ -z "${IMMICH_REMOTE_URL:-}" ]]; then
    echo "Error: IMMICH_REMOTE_URL environment variable is not set"
    exit 1
fi

if [[ -z "${IMMICH_ALBUM_ID:-}" ]]; then
    echo "Error: IMMICH_ALBUM_ID environment variable is not set"
    exit 1
fi

if [[ -z "${IMMICH_API_KEY:-}" ]]; then
    echo "Error: IMMICH_API_KEY environment variable is not set"
    exit 1
fi

if [[ -z "${DOWNLOAD_DIR:-}" ]]; then
    echo "Error: DOWNLOAD_DIR environment variable is not set"
    exit 1
fi

# Debug output (API key is masked for security)
echo "Configuration:"
echo "  Local URL: $IMMICH_LOCAL_URL"
echo "  Remote URL: $IMMICH_REMOTE_URL"
echo "  Album ID: $IMMICH_ALBUM_ID"
echo "  API key: ${IMMICH_API_KEY:0:5}...${IMMICH_API_KEY: -5}"
echo "  Download dir: $DOWNLOAD_DIR"
echo ""

# Create download directory
mkdir -p "$DOWNLOAD_DIR"

echo "Download directory: $DOWNLOAD_DIR"

# Function to test connection to Immich instance
test_connection() {
    local url="$1"
    echo "Testing connection to $url..."
    
    # Try the album endpoint directly since we need it anyway
    local http_code
    local response
    response=$(curl -v -w "\n%{http_code}" -m 10 \
        -H "x-api-key: $IMMICH_API_KEY" \
        "$url/api/albums/$IMMICH_ALBUM_ID" 2>&1)
    http_code=$(echo "$response" | tail -n1)
    
    echo "  Album endpoint returned: $http_code"
    
    if [[ "$http_code" == "200" ]]; then
        return 0
    fi
    
    # Show curl errors if any
    if echo "$response" | grep -q "Could not resolve host"; then
        echo "  ERROR: Could not resolve hostname. Check DNS or use IP address."
    elif echo "$response" | grep -q "Connection refused"; then
        echo "  ERROR: Connection refused. Is Immich running on this URL?"
    elif echo "$response" | grep -q "Connection timed out"; then
        echo "  ERROR: Connection timed out. Check network/firewall."
    fi
    
    # If album check failed, try server ping as fallback
    echo "  Trying ping endpoint..."
    response=$(curl -v -w "\n%{http_code}" -m 10 \
        -H "x-api-key: $IMMICH_API_KEY" \
        "$url/api/server/ping" 2>&1)
    http_code=$(echo "$response" | tail -n1)
    
    echo "  Ping endpoint returned: $http_code"
    
    if [[ "$http_code" == "200" ]]; then
        echo "  (Note: server reachable but album access may have issues)"
        return 0
    fi
    
    echo "  Failed to connect to $url"
    return 1
}

# Determine which URL to use
IMMICH_URL=""

if test_connection "$IMMICH_LOCAL_URL"; then
    echo "✓ Local instance is reachable"
    IMMICH_URL="$IMMICH_LOCAL_URL"
elif test_connection "$IMMICH_REMOTE_URL"; then
    echo "✓ Remote instance is reachable (local failed)"
    IMMICH_URL="$IMMICH_REMOTE_URL"
else
    echo "Error: Neither local nor remote Immich instance is reachable"
    exit 1
fi

echo "Using Immich instance: $IMMICH_URL"

# Get album information
echo "Fetching album information..."
ALBUM_INFO=$(curl -s -f \
    -H "x-api-key: $IMMICH_API_KEY" \
    "$IMMICH_URL/api/albums/$IMMICH_ALBUM_ID")

if [[ -z "$ALBUM_INFO" ]]; then
    echo "Error: Failed to fetch album information"
    exit 1
fi

# Extract album name and asset count
ALBUM_NAME=$(echo "$ALBUM_INFO" | jq -r '.albumName // "unknown"')
ASSET_COUNT=$(echo "$ALBUM_INFO" | jq -r '.assetCount // 0')

echo "Album: $ALBUM_NAME"
echo "Assets: $ASSET_COUNT"

if [[ "$ASSET_COUNT" -eq 0 ]]; then
    echo "No assets found in album"
    exit 0
fi

# Create album-specific directory
ALBUM_DIR="$DOWNLOAD_DIR/${ALBUM_NAME// /_}"
mkdir -p "$ALBUM_DIR"

echo "Downloading to: $ALBUM_DIR"

# Extract asset IDs
ASSET_IDS=$(echo "$ALBUM_INFO" | jq -r '.assets[].id')

if [[ -z "$ASSET_IDS" ]]; then
    echo "Error: No asset IDs found in album"
    exit 1
fi

# Download each asset
COUNT=0
TOTAL=$(echo "$ASSET_IDS" | wc -l)

while IFS= read -r ASSET_ID; do
    COUNT=$((COUNT + 1))
    echo "[$COUNT/$TOTAL] Downloading asset $ASSET_ID..."
    
    # Get asset info to determine filename
    ASSET_INFO=$(curl -s -f \
        -H "x-api-key: $IMMICH_API_KEY" \
        "$IMMICH_URL/api/assets/$ASSET_ID")
    
    ORIGINAL_FILENAME=$(echo "$ASSET_INFO" | jq -r '.originalFileName // "unknown"')
    FILE_EXT=$(echo "$ASSET_INFO" | jq -r '.originalPath' | grep -oE '\.[^.]+$' || echo ".jpg")
    
    # Use original filename if available, otherwise use asset ID
    if [[ "$ORIGINAL_FILENAME" != "unknown" ]]; then
        OUTPUT_FILE="$ALBUM_DIR/$ORIGINAL_FILENAME"
    else
        OUTPUT_FILE="$ALBUM_DIR/${ASSET_ID}${FILE_EXT}"
    fi
    
    # Skip if file already exists
    if [[ -f "$OUTPUT_FILE" ]]; then
        echo "  ↳ Skipped (already exists): $OUTPUT_FILE"
        continue
    fi
    
    # Download the asset
    if curl -s -f \
        -H "x-api-key: $IMMICH_API_KEY" \
        "$IMMICH_URL/api/assets/$ASSET_ID/original" \
        -o "$OUTPUT_FILE"; then
        echo "  ✓ Downloaded: $OUTPUT_FILE"
    else
        echo "  ✗ Failed to download: $ASSET_ID"
    fi
    
done <<< "$ASSET_IDS"

echo ""
echo "Download complete!"
echo "Total assets: $TOTAL"
echo "Location: $ALBUM_DIR"
