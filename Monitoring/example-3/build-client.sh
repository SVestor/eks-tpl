#!/bin/bash

# Print commands (for debugging)
set -x

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Version ---
VERSION="${VERSION:-"v1.0.1-$(date +%Y-%m-%d)"}"
IMAGE="svestor/app-client:${VERSION}"

echo -e "${YELLOW}🚀 Starting Docker build for image: ${IMAGE}${NC}"

# --- Build image ---
if docker build -t "$IMAGE" -f app/client/Dockerfile --platform linux/amd64 app/client; then
  echo -e "${GREEN}✅ Build succeeded for ${IMAGE}${NC}"
else
  echo -e "${RED}❌ Build failed. Exiting.${NC}"
  exit 1
fi

# --- Push image ---
echo -e "${YELLOW}📤 Pushing image to Docker Hub: ${IMAGE}${NC}"

if docker push "$IMAGE"; then
  echo -e "${GREEN}✅ Push succeeded!${NC}"
else
  echo -e "${RED}❌ Push failed. Check your Docker login and network.${NC}"
  exit 1
fi

echo -e "${GREEN}🎉 All done! Image available as ${IMAGE}${NC}"
