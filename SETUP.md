# Quick Setup Guide

## What's Included

This repository contains **22 dashboards** organized into 5 categories, replicated across 4 scenarios:

### Dashboards by Category

- **Monitoring** (5): System Overview, CPU Metrics, Memory Metrics, Disk I/O, Network Traffic
- **Applications** (5): API Performance, Database Metrics, Web Analytics, Service Health, Application Logs
- **Infrastructure** (5): Kubernetes Cluster, Docker Containers, Load Balancers, Cloud Resources, Networking
- **Business** (4): Revenue Metrics, User Engagement, Sales Pipeline, KPI Overview
- **Security** (3): Security Overview, Access Control, Vulnerability Scan

### Scenarios

1. **grafana/** - Default setup with all 22 dashboards
2. **grafana-dev/** - Development environment (port 3001)
3. **grafana-prod/** - Production environment (port 3002)
4. **grafana-mirror/** - Mirror setup (port 3003)

## Quick Start

### 1. Start All Grafana Instances

```bash
docker-compose up -d
```

### 2. Access Instances

- **Default**: http://localhost:3000 (admin/admin)
- **Dev**: http://localhost:3001 (admin/admin)
- **Prod**: http://localhost:3002 (admin/admin)
- **Mirror**: http://localhost:3003 (admin/admin)

### 3. Configure Git Sync

For each instance:

1. Go to **Administration** → **Git Sync**
2. Click **"Connect to GitHub"**
3. Authorize Grafana
4. Configure:
   - **Repository**: Your GitHub repository URL
   - **Branch**: `main`
   - **Path**: `grafana/` (or `grafana-dev/`, `grafana-prod/`, `grafana-mirror/`)
   - **PAT**: Your GitHub Personal Access Token (needs `repo` scope)

### 4. Verify Sync

1. Dashboards should appear in each Grafana instance
2. Make a change to a dashboard in the UI
3. Check that it commits to your Git repository
4. Edit a dashboard JSON file in Git
5. Verify changes appear in Grafana (within 60 seconds)

## Dashboard Format

All dashboards use Grafana Dashboard CRD format:

```json
{
  "apiVersion": "dashboard.grafana.app/v1beta1",
  "kind": "Dashboard",
  "metadata": {
    "name": "dashboard-uid"
  },
  "spec": {
    // Dashboard configuration here
  }
}
```

## Using TestData Datasource

All dashboards use the built-in **TestData** datasource:
- No external data sources required
- Uses `random_walk` scenario for realistic metrics
- Works immediately after Grafana starts

## Common Commands

```bash
# Start all instances
docker-compose up -d

# View logs
docker logs grafana-default
docker logs grafana-dev

# Stop all instances
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v

# Restart single instance
docker-compose restart grafana-default
```

## Troubleshooting

### Dashboards Not Showing

```bash
# Check if containers are running
docker-compose ps

# View Grafana logs
docker logs grafana-default

# Restart instance
docker-compose restart grafana-default
```

### Git Sync Issues

1. Verify GitHub PAT has `repo` permissions
2. Check repository URL and branch name
3. Ensure path matches your directory structure
4. Review Git Sync status in Grafana UI

### Port Conflicts

If ports 3000-3003 are in use:

1. Edit `docker-compose.yml`
2. Change port mappings (e.g., `3000:3000` → `3100:3000`)
3. Restart: `docker-compose down && docker-compose up -d`

## Next Steps

1. **Explore Dashboards**: Browse the pre-built dashboards in each category
2. **Test Git Sync**: Make changes and watch them sync to GitHub
3. **Create PRs**: Edit dashboards and submit pull requests from Grafana UI
4. **Customize**: Modify dashboards for your use case
5. **Add Data Sources**: Connect real data sources for production use

## Resources

- Full documentation: See `README.md`
- Git Sync docs: https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/
- Demo repository: https://github.com/grafana/grafana-git-sync-demo
