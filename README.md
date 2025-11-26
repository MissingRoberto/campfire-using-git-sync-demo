# Grafana Git Sync Demo Repository

Demonstration of Grafana's Git Sync feature with two practical scenarios.

> ⚠️ **Note**: Git Sync is experimental. Not recommended for production.

## Scenarios

### Scenario 1: Default Setup

Single Grafana instance with Git Sync.

[→ Scenario 1 Guide](scenario-1-default/README.md)

### Scenario 2: Dev/Prod Environments

Two instances demonstrating dashboard promotion workflow.

[→ Scenario 2 Guide](scenario-2-dev-prod/README.md)

## Prerequisites

- Docker & Docker Compose
- Ngrok account ([ngrok.com](https://ngrok.com))
- GitHub account with Personal Access Token

## Quick Start

### 1. Configure Environment

```bash
# At repository root
cp .env.example .env
# Edit .env with your ngrok token
```

### 2. Choose and Start a Scenario

```bash
cd scenario-1-default
make start
```

### 3. Get Ngrok URL

```bash
make ngrok-url
```

### 4. Access Grafana

Open the ngrok URL and login with `admin` / `admin`

### 5. Configure Git Sync

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: Scenario-specific path (see scenario README)
   - **Personal Access Token**: Your GitHub PAT
4. Click **"Finish"**

## Makefile Commands

All scenarios include a Makefile with helpful commands:

```bash
make help          # Show all available commands
make start         # Start services
make open          # Open Grafana in browser
make ngrok-url     # Get public URL
make logs          # View logs
make health        # Check service health
make stop          # Stop services
make clean         # Remove all containers and volumes
```

## Git Sync Workflow

### Creating Dashboards

**In Grafana**:
1. Create dashboard
2. Save and choose: "Push to main" or "Create new branch"
3. Enter commit message
4. Click "Open Pull Request" if using branch workflow

**In Git**:
1. Create dashboard JSON in CRD format
2. Commit and push
3. Grafana syncs automatically (60s interval)

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

## Troubleshooting

### Ngrok Issues

```bash
make ngrok-url          # Get current URL
docker-compose logs ngrok
docker-compose restart ngrok
```

### Git Sync Not Working

1. Verify GitHub PAT has correct permissions (repo, pull requests, webhooks)
2. Check repository path matches directory structure
3. Review Grafana logs: `make logs`
4. Ensure ngrok URL is accessible

### Dashboards Not Appearing

1. Check Git Sync status: Administration → Provisioning
2. Wait 60s for sync interval
3. Force sync via UI: Pull button
4. Verify dashboard CRD format is correct

### Service Health

```bash
make health     # Check all services
make status     # Show container status
```

## Resources

- [Git Sync Documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/)
- [Git Sync Setup Guide](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/git-sync-setup/)
- [Official Demo Repository](https://github.com/grafana/grafana-git-sync-demo)
