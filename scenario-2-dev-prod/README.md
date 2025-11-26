# Scenario 2: Dev/Prod Environment Setup

This scenario demonstrates how to manage separate development and production Grafana instances with Git Sync, each syncing to different paths in the repository.

## Overview

- **Two Instances**: Development and Production
- **Separate Tunnels**: Each environment has its own ngrok URL
- **Independent Sync**: Dev and Prod sync to different repository paths
- **Environment Promotion**: Test changes in dev before promoting to prod

## Directory Structure

```
scenario-2-dev-prod/
├── dev/
│   └── grafana/          # 22 dev dashboards
│       ├── monitoring/
│       ├── applications/
│       ├── infrastructure/
│       ├── business/
│       └── security/
├── prod/
│   └── grafana/          # 22 prod dashboards
│       ├── monitoring/
│       ├── applications/
│       ├── infrastructure/
│       ├── business/
│       └── security/
├── docker-compose.yml
├── .env.example
└── README.md
```

## Prerequisites

1. **Docker & Docker Compose** installed
2. **Ngrok account** with support for 2 tunnels (free tier allows 1, paid tier multiple)
3. **GitHub account** with Personal Access Token (`repo` scope)

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
nano .env
```

Required values:
```env
NGROK_AUTHTOKEN=your_ngrok_token
NGROK_SUBDOMAIN_DEV=your-dev-subdomain.ngrok-free.app
NGROK_SUBDOMAIN_PROD=your-prod-subdomain.ngrok-free.app
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=admin
```

**Note**: Free ngrok tier allows only 1 tunnel. For this scenario, you need:
- **Option A**: Paid ngrok plan (supports multiple tunnels)
- **Option B**: Two separate ngrok accounts
- **Option C**: Run dev and prod separately (not simultaneously)

### 2. Start Services

**Option 1: Start Both (requires paid ngrok)**
```bash
docker-compose up -d
```

**Option 2: Start Dev Only**
```bash
docker-compose up -d grafana-dev renderer-dev ngrok-dev
```

**Option 3: Start Prod Only**
```bash
docker-compose up -d grafana-prod renderer-prod ngrok-prod
```

### 3. Access Instances

**Development**:
- URL: Check ngrok-dev logs for URL
- Local: http://localhost:3000
- Login: admin/admin

**Production**:
- URL: Check ngrok-prod logs for URL
- Local: http://localhost:3001
- Login: admin/admin

```bash
# Get ngrok URLs
docker-compose logs ngrok-dev | grep "started tunnel"
docker-compose logs ngrok-prod | grep "started tunnel"
```

## Setting Up Git Sync

### Development Environment

1. Access dev Grafana at your ngrok-dev URL
2. Go to **Administration** → **Git Sync**
3. Configure:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main` or `dev`
   - **Path**: `scenario-2-dev-prod/dev/grafana/`
   - **PAT**: Your GitHub token
4. Enable Auto Sync

### Production Environment

1. Access prod Grafana at your ngrok-prod URL
2. Go to **Administration** → **Git Sync**
3. Configure:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-2-dev-prod/prod/grafana/`
   - **PAT**: Your GitHub token
4. Enable Auto Sync

## Workflow: Dev to Prod Promotion

### Recommended Git Branch Strategy

```
main (production)
  └── dev (development)
      └── feature/your-feature
```

### Step 1: Develop in Dev Environment

1. Make changes in **Dev Grafana** (via ngrok-dev URL)
2. Save dashboard → Auto commits to dev branch
3. Create PR from Grafana UI
4. Review PR with dashboard preview
5. Merge PR to dev branch

### Step 2: Test in Dev

1. Verify changes work in dev environment
2. Test with stakeholders
3. Validate dashboard functionality
4. Check for any issues

### Step 3: Promote to Prod

**Option A: Via Git (Recommended)**
```bash
# Merge dev branch to main
git checkout main
git pull origin main
git merge dev
git push origin main

# Prod Grafana syncs automatically
```

**Option B: Manual Copy**
```bash
# Copy specific dashboard from dev to prod
cp scenario-2-dev-prod/dev/grafana/monitoring/cpu-metrics.json \
   scenario-2-dev-prod/prod/grafana/monitoring/cpu-metrics.json

git add scenario-2-dev-prod/prod/grafana/monitoring/cpu-metrics.json
git commit -m "Promote CPU metrics dashboard to prod"
git push origin main
```

**Option C: Via Grafana UI**
1. Export dashboard JSON from Dev
2. Import to Prod via Git Sync
3. Commit and push to prod path

### Step 4: Verify in Prod

1. Access Prod Grafana (ngrok-prod URL)
2. Verify dashboard appears after sync
3. Test functionality
4. Monitor for issues

## Use Cases

### Use Case 1: Safe Dashboard Development

```mermaid
Dev → Test → Review → Merge → Prod
```

1. Developer creates dashboard in Dev
2. Team reviews in Dev environment
3. Create PR, stakeholders preview
4. Merge to main
5. Auto-sync to Prod

### Use Case 2: A/B Testing

- Test different dashboard versions in Dev
- Compare metrics and layouts
- Promote winning version to Prod

### Use Case 3: Breaking Change Prevention

- Test data source changes in Dev first
- Verify plugin compatibility
- Ensure queries work before Prod deployment

### Use Case 4: Training Environment

- Use Dev as training instance
- Allow users to experiment safely
- Prod remains stable and unchanged

## Environment Differences

### Development
- ✅ Experimental features enabled
- ✅ Less restrictive permissions
- ✅ Frequent changes allowed
- ✅ Can have downtime
- ✅ Syncs to `dev` branch

### Production
- ✅ Stable, tested dashboards only
- ✅ Restricted access
- ✅ Change control required
- ✅ High availability expected
- ✅ Syncs to `main` branch

## Troubleshooting

### Only One Ngrok Tunnel Works

**Cause**: Free ngrok tier limits to 1 tunnel

**Solutions**:
1. Upgrade to paid ngrok plan
2. Use two ngrok accounts (separate authtokens)
3. Run dev and prod at different times

### Dev and Prod Dashboards Out of Sync

```bash
# Check sync status in each Grafana instance
# Review last sync time in Git Sync settings

# Force sync in Grafana UI
# Or trigger webhook manually
```

### Changes Not Appearing in Other Environment

1. Verify correct branch configuration
2. Check repository paths match folder structure
3. Confirm polling interval elapsed (60s default)
4. Review Git Sync logs in Grafana

### Port Conflicts

If ports 3000-3001 are in use:
```yaml
# Edit docker-compose.yml
ports:
  - "3100:3000"  # Change dev port
  - "3101:3000"  # Change prod port
```

## Advanced Configuration

### Using Different Branches

```yaml
# Dev → dev branch
# Prod → main branch

# In .env or Grafana Git Sync config
# Specify branch per environment
```

### Automated Promotion Pipeline

```yaml
# .github/workflows/promote-to-prod.yml
name: Promote Dev to Prod
on:
  workflow_dispatch:
jobs:
  promote:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Merge dev to main
        run: |
          git checkout main
          git merge dev
          git push origin main
```

### Environment-Specific Variables

Use different data sources or settings per environment:
- Dev: Test data sources
- Prod: Production data sources

## Stopping Services

```bash
# Stop all
docker-compose down

# Stop dev only
docker-compose stop grafana-dev renderer-dev ngrok-dev

# Stop prod only
docker-compose stop grafana-prod renderer-prod ngrok-prod

# Clean slate
docker-compose down -v
```

## Next Steps

1. ✅ Set up dev environment first
2. ✅ Create test dashboard in dev
3. ✅ Verify Git Sync works
4. ✅ Promote to prod
5. ✅ Establish promotion workflow
