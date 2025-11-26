# Scenario 2: Dev/Prod Setup

Separate development and production Grafana instances with independent Git Sync paths.

## Overview

- Two instances: Dev and Prod
- Separate ngrok tunnels
- Independent Git paths
- Promote changes from dev to prod

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit with both ngrok tokens/subdomains
```

**Note**: Free ngrok allows 1 tunnel. Options:
- Paid ngrok (multiple tunnels)
- Two ngrok accounts
- Run dev and prod separately

### 2. Start Services

```bash
# Both instances (requires paid ngrok)
docker-compose up -d

# Dev only
docker-compose up -d grafana-dev renderer-dev ngrok-dev

# Prod only
docker-compose up -d grafana-prod renderer-prod ngrok-prod
```

### 3. Access Instances

**Dev**: http://localhost:3000 or ngrok-dev URL
**Prod**: http://localhost:3001 or ngrok-prod URL

Login: `admin` / `admin`

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

1. Make changes in Dev Grafana
2. Save and create PR
3. Review and merge

### 2. Test in Dev

1. Verify changes work
2. Test with team
3. Check for issues

### 3. Promote to Prod

**Option A: Copy Files**
```bash
cp scenario-2-dev-prod/dev/monitoring/dashboard.json \
   scenario-2-dev-prod/prod/monitoring/dashboard.json
git add .
git commit -m "Promote dashboard to prod"
git push
```

**Option B: Git Merge**
```bash
# If using separate branches
git checkout main
git merge dev
git push
```

### 4. Verify in Prod

1. Check dashboard appears in Prod
2. Test functionality
3. Monitor for issues

## Common Commands

```bash
# Start both
docker-compose up -d

# Logs
docker-compose logs -f grafana-dev
docker-compose logs -f grafana-prod

# Stop
docker-compose down

# Clean slate
docker-compose down -v
```

## Troubleshooting

### Only One Ngrok Tunnel Works

Free tier limits to 1 tunnel. Solutions:
1. Paid ngrok plan
2. Two ngrok accounts
3. Run dev/prod separately

### Dashboards Out of Sync

1. Check Git Sync status in each instance
2. Verify correct repository paths
3. Wait for sync interval (60s)
4. Force sync via UI
