#!/bin/bash

COMPOSE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if SearXNG is running (suppress all output)
if ! docker compose -f "$COMPOSE_DIR/docker-compose.yml" ps 2>/dev/null | grep -q "Up"; then
  docker compose -f "$COMPOSE_DIR/docker-compose.yml" up -d >/dev/null 2>&1
  sleep 2
fi

# Check if mcp-server-searxng is installed
if ! command -v mcp-server-searxng &> /dev/null; then
  echo "Error: mcp-server-searxng not installed. Run: npm install -g @kevinwatt/mcp-server-searxng" >&2
  exit 1
fi

# Start mcp-server-searxng
exec mcp-server-searxng
