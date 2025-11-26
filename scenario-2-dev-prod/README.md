# Scenario 2: Dev/Prod Setup

Separate development and production Grafana instances with independent Git Sync paths.

## Overview

- Two instances: Dev and Prod
- Single ngrok tunnel (free tier limitation)
- Independent Git paths
- Promote changes from dev to prod

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit with your ngrok token
```

**Note**: Free ngrok allows only 1 tunnel. Both instances run, but ngrok exposes only one (dev by default).

### 2. Start Services

```bash
docker-compose up -d
```

### 3. Access Instances

**Dev**: http://localhost:3000 or ngrok URL
**Prod**: http://localhost:3001 (local only)

Login: `admin` / `admin`

### 4. Get Ngrok URL

```bash
docker-compose logs ngrok | grep "started tunnel"
```

## Configure Git Sync

### Dev Instance

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main` or `dev`
   - **Path**: `scenario-2-dev-prod/dev/`
   - **PAT**: Your GitHub token

### Prod Instance

1. Same steps as dev
2. Use **Path**: `scenario-2-dev-prod/prod/`

## Workflow: Dev to Prod

### 1. Develop in Dev

1. Make changes in Dev Grafana (port 3000)
2. Save and create PR
3. Review and merge

### 2. Test in Dev

1. Verify changes work
2. Test with team
3. Check for issues

### 3. Promote to Prod

**Copy dashboards:**
```bash
cp scenario-2-dev-prod/dev/monitoring/dashboard.json \
   scenario-2-dev-prod/prod/monitoring/dashboard.json
git add .
git commit -m "Promote dashboard to prod"
git push
```

### 4. Verify in Prod

1. Check dashboard appears in Prod (port 3001)
2. Test functionality

## Switching Ngrok Tunnel

To expose prod instead of dev, edit docker-compose.yml:

```yaml
ngrok:
  command: http grafana-prod:3000  # Change from grafana-dev:3000
```

Then restart: `docker-compose restart ngrok`

## Common Commands

```bash
# Start both
docker-compose up -d

# Logs
docker-compose logs -f grafana-dev
docker-compose logs -f grafana-prod

# Stop
docker-compose down
```

## Troubleshooting

### Ngrok Only Exposes One Instance

This is expected with free tier. Access the other instance via localhost:3001.

### Dashboards Out of Sync

1. Check Git Sync status in each instance
2. Verify correct repository paths
3. Wait for sync interval (60s)
4. Force sync via UI
