# Grafana Git Sync Demo Repository

> **Last Updated:** November 28, 2025
>
> **Purpose:** This repository provides practical demonstrations of Grafana's Git Sync feature through four real-world scenarios. It's designed to help DevOps engineers, SREs, and Grafana users learn how to implement bidirectional synchronization between Grafana dashboards and Git repositories.

## ⚠️ Important Disclaimers

- **Experimental Feature**: Git Sync is currently in an experimental phase and may have limitations or breaking changes. While it represents Grafana's first step toward comprehensive Observability as Code, **we don't recommend using it in production or critical environments**.

- **Evolving Documentation**: This documentation reflects the state of Git Sync as of November 2025. As this feature is actively evolving, some instructions may become outdated. Please refer to the [official Grafana Git Sync documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/) for the latest information.

## Overview

Demonstration of Grafana's Git Sync feature with four practical scenarios covering common deployment patterns.

## Scenarios

### Scenario 1: Default Setup

Single Grafana instance with Git Sync.

[→ Scenario 1 Guide](scenario-1-default/README.md)

### Scenario 2: Dev/Prod Environments

Two instances demonstrating dashboard promotion workflow.

[→ Scenario 2 Guide](scenario-2-dev-prod/README.md)

### Scenario 3: Multi-Region Deployment

Multiple instances syncing from the same shared directory.

[→ Scenario 3 Guide](scenario-3-multi-region/README.md)

### Scenario 4: Master-Replica with Load Balancer

High availability setup with master-replica instances and easy failover.

[→ Scenario 4 Guide](scenario-4-master-replica/README.md)

## Prerequisites

- Docker & Docker Compose
- Ngrok account with static subdomain ([ngrok.com](https://ngrok.com))
- GitHub account with Personal Access Token (scopes: repo, pull_requests, webhooks)
- grafanactl CLI ([installation instructions](https://grafana.github.io/grafanactl/))

## Quick Start

### 1. Fork this Repository

Click the "Fork" button on GitHub to create your own copy of this repository. You'll need to push changes to your fork for Git Sync to work.

### 2. Configure Environment

```bash
# At repository root
cp .env.example .env
```

Edit `.env` and configure:
- `NGROK_AUTHTOKEN`: Your ngrok auth token
- `NGROK_SUBDOMAIN`: Your static ngrok subdomain (e.g., `https://your-subdomain.ngrok-free.app`)
- `GITHUB_PAT`: Your GitHub Personal Access Token
- `GITHUB_REPO`: Your forked repository (e.g., `yourusername/campfire-using-git-sync-demo`)
- `GITHUB_BRANCH`: Branch to sync (usually `main`)

### 3. Choose and Start a Scenario

```bash
# Example: Start scenario 2
cd scenario-2-dev-prod
make start
```

### 4. Configure Git Sync

After services start, run the setup script to configure Git Sync:

```bash
make setup-git-sync
```

This will:
- Wait for Grafana instances to be ready
- Create Repository resources via grafanactl
- Configure bidirectional sync with your GitHub fork

### 5. Verify Setup

```bash
# Get public URL
make ngrok-url

# Check Git Sync status
grafanactl --config=grafanactl.yaml resources get repositories
```

Access Grafana at `http://localhost:3000` (or the appropriate port) and login with `admin` / `admin`. Your dashboards should be synced from Git!

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

## Using grafanactl

Each scenario includes a `grafanactl.yaml` configuration file for CLI management. To use grafanactl:

### Installation

```bash
# Install grafanactl (see https://grafana.github.io/grafanactl/)
brew install grafanactl  # macOS
# or download from releases page
```

### Usage

```bash
# Navigate to scenario directory
cd scenario-2-dev-prod

# List available contexts
grafanactl --config=grafanactl.yaml config get-contexts

# Switch context (scenario 2, 3, 4 only)
grafanactl --config=grafanactl.yaml config use-context prod

# List dashboards
grafanactl --config=grafanactl.yaml resources get dashboards

# Get specific dashboard
grafanactl --config=grafanactl.yaml resources get dashboard/<name>

```

### Context Names by Scenario

- **Scenario 1**: `default`
- **Scenario 2**: `dev`, `prod`
- **Scenario 3**: `us`, `eu`
- **Scenario 4**: `master`, `replica`, `load-balancer`

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
