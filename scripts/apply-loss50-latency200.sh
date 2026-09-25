#!/usr/bin/env bash

set -Eeuo pipefail

PROXY="${1:-wifi-path}"

echo "========================================"
echo "VRP Open Failure Challenge"
echo "Applying latency impairment"
echo "Proxy: ${PROXY}"
echo "========================================"

docker run --rm \
  --network host \
  --entrypoint /toxiproxy-cli \
  ghcr.io/shopify/toxiproxy:2.12.0 \
  toxic add \
  --type latency \
  --toxicName latency200 \
  --attribute latency=200 \
  --attribute jitter=0 \
  "${PROXY}"

echo
echo "Installed toxics:"
docker run --rm \
  --network host \
  --entrypoint /toxiproxy-cli \
  ghcr.io/shopify/toxiproxy:2.12.0 \
  inspect "${PROXY}"

echo
echo "FINAL_VERDICT=LATENCY200_APPLIED"
