# Scenario 1: Default Setup

Single Grafana instance with Git Sync.

## Architecture

```mermaid
graph LR
    User[User] --> Ngrok[Ngrok Tunnel]
    Ngrok --> Grafana[Grafana Instance]
    Grafana <--> |Git Sync| GitHub[GitHub Repository]
    Grafana --> Renderer[Image Renderer]

    style Grafana fill:#f96332
    style GitHub fill:#333
    style Ngrok fill:#1f8fff
```

## What's Included

- Single Grafana instance with ngrok tunnel
- Demo dashboards in applications/ folder
- Image rendering for PR previews

## Quick Start

```bash
# From repository root - configure .env once
cp .env.example .env
# Edit .env with your ngrok token

# Start this scenario
cd scenario-1-default
make start

# Get public URL
make ngrok-url

# Open in browser
make open
```

Login: `admin` / `admin`

## Configure Git Sync

**Path for this scenario**: `scenario-1-default/grafana/`

See [main README](../README.md#quick-start) for full Git Sync setup instructions.

## Makefile Commands

```bash
make start         # Start services
make open          # Open Grafana
make ngrok-url     # Get public URL
make logs          # View logs
make stop          # Stop services
```

See [main README](../README.md#makefile-commands) for all commands.

## Troubleshooting

See [main README troubleshooting section](../README.md#troubleshooting).
