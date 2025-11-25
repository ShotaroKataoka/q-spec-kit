# SearXNG for Q-SPEC Kit

Self-hosted SearXNG search engine for privacy-focused web search.

## Setup

### Quick Start

```bash
# Run Q-SPEC Kit setup and select "searxng"
./setup.sh
```

**That's it!** SearXNG will automatically start when the agent uses it.

### Manual Start (Optional)

```bash
cd mcps/searxng
docker compose up -d
```

### Verify

```bash
# Check if running
docker compose ps

# Test search
curl "http://localhost:8080/search?q=test&format=json"
```

## Management

```bash
# Stop
docker compose down

# View logs
docker compose logs -f

# Restart
docker compose restart
```

## Configuration

Edit `settings.yml` to customize:
- Search engines
- UI theme
- Safe search level
- Language preferences

After changes:
```bash
docker compose restart
```

## Security

**Important**: Change `secret_key` in `settings.yml` before production use:
```bash
openssl rand -hex 32
```

## Troubleshooting

### Port 8080 already in use
Edit `docker-compose.yml` and change port mapping:
```yaml
ports:
  - "8081:8080"  # Use 8081 instead
```

Then update `SEARXNG_URL` in agent config to `http://localhost:8081`.
