# Scenario 2: Dev/Prod Setup

Demonstrate promoting a dashboard from development to production using Git Sync.

## Overview

- Two instances: Dev and Prod
- Dev has 1 dashboard for promotion demo
- Prod has monitoring dashboards + receives promoted dashboard
- Ngrok tunnel points to Prod (for Git Sync webhooks)
- Promote changes from dev to prod via Git

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit with your ngrok token
```

### 2. Start Services

```bash
make start
# Or: docker-compose up -d
```

### 3. Access Instances

**Dev**: http://localhost:3000 (local only)
**Prod**: http://localhost:3001 or ngrok URL

Login: `admin` / `admin`

### 4. Get Ngrok URL

```bash
make ngrok-url
# Or: docker-compose logs ngrok | grep "started tunnel"
```

## Configure Git Sync

### Dev Instance (http://localhost:3000)

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-2-dev-prod/dev/`
   - **PAT**: Your GitHub token
4. **Sync Mode**: Bidirectional

### Prod Instance (http://localhost:3001 or ngrok URL)

1. Same steps as dev
2. Use **Path**: `scenario-2-dev-prod/prod/`
3. **Sync Mode**: Bidirectional

## Workflow: Promote Dashboard from Dev to Prod

### Option A: Using Makefile

```bash
# 1. Edit dashboard in Dev Grafana (http://localhost:3000)
# 2. Save changes in Dev

# 3. Promote to prod
make promote

# 4. Commit and push
git add prod/promoted-from-dev.json
git commit -m "Promote dashboard to prod"
git push

# 5. Verify in Prod
make open-prod
```

### Option B: Manual

```bash
# 1. Edit dashboard in Dev Grafana
# 2. Save changes

# 3. Copy dashboard file
cp dev/new-dashboard.json prod/promoted-from-dev.json

# 4. Commit and push
git add prod/promoted-from-dev.json
git commit -m "Promote dashboard to prod"
git push

# 5. Wait for Git Sync (60s) or force sync in Prod UI
```

## Makefile Commands

```bash
make help          # Show all available commands
make start         # Start all services
make open-dev      # Open Dev Grafana
make open-prod     # Open Prod Grafana
make open-all      # Open both + ngrok dashboard
make promote       # Promote dev dashboard to prod
make logs-dev      # View dev logs
make logs-prod     # View prod logs
make health        # Check service health
make stop          # Stop all services
```

## Common Commands

```bash
# Start
make start

# Open dashboards
make open-all

# View logs
make logs-dev
make logs-prod

# Promote dashboard
make promote

# Stop
make stop
```

## Troubleshooting

### Ngrok Only Exposes Prod

This is intentional. Dev is for local editing only. Prod needs public URL for Git Sync webhooks.

### Dashboard Not Appearing in Prod

1. Check Git Sync status in Prod UI
2. Verify file was committed and pushed
3. Wait 60s for sync interval
4. Force sync via UI: Administration → Provisioning → Pull

### Promote Command Not Working

Ensure you're in the scenario-2-dev-prod directory and `dev/new-dashboard.json` exists.
