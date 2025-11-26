# Scenario 3: Primary/Mirror Setup

Two Grafana instances syncing from the same Git directory for disaster recovery and high availability.

## Overview

- Two instances: Primary and Mirror
- Both sync from same Git directory
- Single ngrok tunnel (free tier limitation)
- Disaster recovery and failover

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit with your ngrok token
```

**Note**: Free ngrok allows only 1 tunnel. Both instances run, but ngrok exposes only one (primary by default).

### 2. Start Services

```bash
docker-compose up -d
```

### 3. Access Instances

**Primary**: http://localhost:3000 or ngrok URL
**Mirror**: http://localhost:3001 (local only)

Login: `admin` / `admin`

### 4. Get Ngrok URL

```bash
docker-compose logs ngrok | grep "started tunnel"
```

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

## Synchronization

Both instances sync from the same Git directory:
- Primary pushes changes to Git
- Mirror pulls changes from Git
- Automatic synchronization every 60s
- Both instances stay identical

## Failover Process

1. Primary goes down
2. Switch ngrok tunnel to mirror
3. Mirror serves all requests
4. When primary recovered, it syncs from Git automatically

## Switching Ngrok Tunnel

To expose mirror instead of primary, edit docker-compose.yml:

```yaml
ngrok:
  command: http grafana-mirror:3000  # Change from grafana-primary:3000
```

Then restart: `docker-compose restart ngrok`

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
```

## Troubleshooting

### Ngrok Only Exposes One Instance

This is expected with free tier. Access the other instance via localhost:3001.

### Mirror Behind Primary

1. Check Git Sync status
2. Force sync via UI
3. Review sync logs

### Dashboards Different

1. Verify both use same repository path
2. Check last sync time
3. Force sync on mirror
