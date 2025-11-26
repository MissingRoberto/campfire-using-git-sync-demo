# Grafana Git Sync Demo Repository

Demonstration of Grafana's Git Sync feature with 22 demo dashboards across three scenarios.

## Overview

This repository shows how to use Grafana's Git Sync feature for version controlling dashboards:

- Version control dashboards with Git
- Collaborate using Git workflows
- Bidirectional sync between Grafana and Git
- PR previews with screenshots
- Public access via ngrok

> ⚠️ **Note**: Git Sync is experimental. Not recommended for production.

## Repository Structure

```
campfire-using-git-sync-demo/
├── scenario-1-default/           # Single instance setup
│   ├── grafana/                  # 22 demo dashboards
│   ├── docker-compose.yml
│   └── .env.example
├── scenario-2-dev-prod/          # Dev/Prod environments
│   ├── dev/                      # 22 dev dashboards
│   ├── prod/                     # 22 prod dashboards
│   ├── docker-compose.yml
│   └── .env.example
└── scenario-3-mirror/            # Primary/Mirror setup
    ├── grafana/                  # 22 dashboards (shared by both)
    ├── docker-compose.yml
    └── .env.example
```

## Scenarios

### Scenario 1: Default Setup

Single Grafana instance with Git Sync.

- Single instance with ngrok
- 22 demo dashboards
- Image rendering for PR previews

[→ Scenario 1 Guide](scenario-1-default/README.md)

### Scenario 2: Dev/Prod Environments

Separate development and production instances.

- Dev and Prod instances
- Independent ngrok tunnels
- Promote changes from dev to prod

[→ Scenario 2 Guide](scenario-2-dev-prod/README.md)

### Scenario 3: Primary/Mirror Setup

Two instances for disaster recovery and high availability.

- Primary and Mirror instances
- Failover capability
- Geo-distribution

[→ Scenario 3 Guide](scenario-3-mirror/README.md)

## Quick Start

### Prerequisites

- Docker & Docker Compose
- Ngrok account ([ngrok.com](https://ngrok.com))
- GitHub account with Personal Access Token

### Setup

```bash
# Choose a scenario
cd scenario-1-default

# Configure environment
cp .env.example .env
# Edit .env with your ngrok token

# Start services
docker-compose up -d

# Get your public URL
docker-compose logs ngrok | grep "started tunnel"
```

### Access Grafana

Open your ngrok URL and login:
- Username: `admin`
- Password: `admin`

### Configure Git Sync

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter details:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: Your scenario path (e.g., `scenario-1-default/grafana/`)
   - **Personal Access Token**: Your GitHub PAT
4. Click **"Finish"**

📖 **Detailed Guide**: [GIT-SYNC-UI-GUIDE.md](GIT-SYNC-UI-GUIDE.md)

## Git Sync Workflow

### Creating Dashboards

**In Grafana**:
1. Create dashboard
2. Save and choose workflow: "Push to main" or "Create new branch"
3. Enter commit message
4. Click "Open Pull Request" if using branch workflow

**In Git**:
1. Create dashboard JSON in CRD format
2. Commit and push
3. Grafana syncs automatically

### Dashboard Format

```json
{
  "apiVersion": "dashboard.grafana.app/v1beta1",
  "kind": "Dashboard",
  "metadata": {
    "name": "dashboard-uid"
  },
  "spec": {
    // Dashboard configuration
  }
}
```

## Common Commands

```bash
# Start
docker-compose up -d

# View logs
docker-compose logs -f grafana

# Stop
docker-compose down

# Clean slate
docker-compose down -v
```

## Resources

- [Git Sync Documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/)
- [Git Sync Setup Guide](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/git-sync-setup/)
- [Official Demo Repository](https://github.com/grafana/grafana-git-sync-demo)
