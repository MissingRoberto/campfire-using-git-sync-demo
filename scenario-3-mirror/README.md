# Scenario 3: Primary/Mirror Setup

Two Grafana instances syncing from the same Git directory for disaster recovery and high availability.

## Overview

- Two instances: Primary and Mirror
- Both sync from same Git directory
- Separate ngrok tunnels
- Disaster recovery and failover
- Geo-distribution

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit with both ngrok tokens/subdomains
```

**Note**: Free ngrok allows 1 tunnel. Options:
- Paid ngrok (multiple tunnels)
- Two ngrok accounts
- Run primary and mirror separately

### 2. Start Services

```bash
# Both instances (requires paid ngrok)
docker-compose up -d

# Primary only
docker-compose up -d grafana-primary renderer-primary ngrok-primary

# Mirror only
docker-compose up -d grafana-mirror renderer-mirror ngrok-mirror
```

### 3. Access Instances

**Primary**: http://localhost:3000 or ngrok-primary URL
**Mirror**: http://localhost:3001 or ngrok-mirror URL

Login: `admin` / `admin`

## Configure Git Sync

Both instances sync from the same repository path to stay identical.

### Primary Instance

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-3-mirror/grafana/`
   - **PAT**: Your GitHub token
4. **Sync Mode**: Bidirectional (can push changes)

### Mirror Instance

1. Same steps as primary
2. Use same **Path**: `scenario-3-mirror/grafana/`
3. **Sync Mode**: Read-Only (recommended to avoid conflicts)

## Use Cases

### Disaster Recovery

Primary fails → Switch to mirror

```bash
# Update DNS/load balancer to mirror URL
# Mirror continues serving from last sync
```

### High Availability

Both instances serve traffic via load balancer.

### Geo-Distribution

- Primary in one region
- Mirror in another region
- Route users to nearest instance

## Synchronization

Both instances sync from the same Git directory:
- Primary pushes changes to Git
- Mirror pulls changes from Git
- Automatic synchronization every 60s
- Both instances stay identical

### Failover Process

1. Primary goes down
2. Switch traffic to mirror
3. Mirror serves all requests
4. When primary recovered, it syncs from Git automatically

## Common Commands

```bash
# Start both
docker-compose up -d

# Logs
docker-compose logs -f grafana-primary
docker-compose logs -f grafana-mirror

# Health check
curl http://localhost:3000/api/health  # Primary
curl http://localhost:3001/api/health  # Mirror

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
3. Run primary/mirror separately

### Mirror Behind Primary

1. Check Git Sync status
2. Force sync via UI
3. Reduce polling interval
4. Check for Git conflicts

### Dashboards Different

1. Verify both use same repository path
2. Check last sync time
3. Force sync on mirror
4. Review sync logs
