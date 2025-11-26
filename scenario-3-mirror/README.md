# Scenario 3: Mirror Setup

This scenario demonstrates a complete mirror/replica setup for disaster recovery, geographic distribution, or high availability.

## Overview

- **Purpose**: Complete mirror of primary Grafana instance
- **Use Cases**: DR, geo-distribution, load balancing, backup
- **Sync Method**: Git Sync from same repository path
- **Independence**: Runs separately, can fail over if primary fails

## Directory Structure

```
scenario-3-mirror/
├── grafana/              # 22 mirrored dashboards
│   ├── monitoring/
│   ├── applications/
│   ├── infrastructure/
│   ├── business/
│   └── security/
├── docker-compose.yml
├── .env.example
└── README.md
```

## Prerequisites

1. **Docker & Docker Compose**
2. **Ngrok account**
3. **GitHub account** with PAT
4. **Primary Grafana instance** (optional - mirror can run standalone)

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
nano .env
```

```env
NGROK_AUTHTOKEN=your_ngrok_token
NGROK_SUBDOMAIN=your-mirror-subdomain.ngrok-free.app
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=admin
```

### 2. Start Mirror Instance

```bash
docker-compose up -d
```

### 3. Get Public URL

```bash
docker-compose logs ngrok | grep "started tunnel"
# Or visit: https://dashboard.ngrok.com/endpoints
```

### 4. Access Mirror Grafana

Open your ngrok URL and login with admin/admin

## Setting Up Git Sync

### Mirror Configuration

1. In Mirror Grafana, go to **Administration** → **Git Sync**
2. Configure:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-3-mirror/grafana/`
   - **PAT**: Your GitHub token
3. Set **Sync Mode**: "Read-Only" or "Bidirectional"

### Sync Modes

**Read-Only Mode** (Recommended for mirrors):
- ✅ Mirror pulls changes from Git
- ✅ Local changes NOT pushed to Git
- ✅ Prevents conflicts with primary
- ✅ True mirror behavior

**Bidirectional Mode**:
- ✅ Mirror can push changes
- ⚠️ May cause conflicts if primary also writes
- ⚠️ Use only if mirror is active-active

## Use Cases

### 1. Disaster Recovery

**Primary fails** → **Switch to mirror**

```bash
# Update DNS or load balancer to point to mirror ngrok URL
# Mirror continues serving dashboards from last sync
```

**Benefits**:
- RPO: ~60 seconds (polling interval)
- RTO: Immediate (mirror already running)
- Zero data loss if sync completed

### 2. Geographic Distribution

**Setup**:
- Primary in US East
- Mirror in EU West
- Users routed to nearest instance

**Configuration**:
```
Primary: us-east-grafana.ngrok.io
Mirror: eu-west-grafana.ngrok.io
```

### 3. Load Balancing

**Active-Active Setup**:
- Both instances serve traffic
- Load balancer distributes requests
- Both sync from same Git repository

**Load Balancer Config**:
```nginx
upstream grafana {
    server primary-grafana.ngrok.io;
    server mirror-grafana.ngrok.io;
}
```

### 4. Blue-Green Deployments

**Blue** (Current): Primary instance
**Green** (New): Mirror with updated dashboards

```bash
# Deploy to mirror first
# Test thoroughly
# Switch traffic to mirror
# Mirror becomes new primary
```

### 5. Backup & Testing

- Mirror as read-only backup
- Test dashboard changes on mirror
- Verify before deploying to primary

## Mirror Synchronization

### Initial Sync

```bash
# Start mirror
docker-compose up -d

# Wait for Git Sync to connect
# Dashboards auto-sync from repository

# Verify sync
docker-compose logs grafana | grep "sync"
```

### Continuous Sync

Mirror automatically:
- Polls Git every 60 seconds (configurable)
- Pulls new/updated dashboards
- Updates local dashboards

### Force Sync

If sync seems stale:
1. Go to Git Sync settings in Grafana UI
2. Click "Sync Now" button
3. Or restart Grafana: `docker-compose restart grafana`

## High Availability Setup

### Architecture

```
                    ┌─────────────────┐
                    │   GitHub Repo   │
                    └────────┬────────┘
                             │
                 ┌───────────┴───────────┐
                 │                       │
         ┌───────▼──────┐        ┌──────▼──────┐
         │   Primary    │        │    Mirror   │
         │   Grafana    │        │   Grafana   │
         └───────┬──────┘        └──────┬──────┘
                 │                       │
         ┌───────▼──────────────────────▼─────┐
         │        Load Balancer                │
         └────────────────┬────────────────────┘
                          │
                   ┌──────▼──────┐
                   │    Users    │
                   └─────────────┘
```

### Health Checks

```bash
# Check primary
curl https://primary.ngrok.io/api/health

# Check mirror
curl https://mirror.ngrok.io/api/health

# Both should return: {"database":"ok","version":"..."}
```

### Failover Testing

```bash
# Stop primary
docker-compose -f ../scenario-1-default/docker-compose.yml down

# Verify mirror still serves traffic
curl https://mirror.ngrok.io/api/health

# Users automatically routed to mirror
```

## Monitoring Mirror Health

### Key Metrics

1. **Sync Status**: Git Sync last sync time
2. **Lag Time**: Difference between primary and mirror
3. **Dashboard Count**: Should match primary
4. **API Health**: /api/health endpoint

### Monitoring Script

```bash
#!/bin/bash
# check-mirror-health.sh

PRIMARY_URL="https://primary.ngrok.io"
MIRROR_URL="https://mirror.ngrok.io"

# Check health
PRIMARY_HEALTH=$(curl -s $PRIMARY_URL/api/health | jq -r .database)
MIRROR_HEALTH=$(curl -s $MIRROR_URL/api/health | jq -r .database)

echo "Primary: $PRIMARY_HEALTH"
echo "Mirror: $MIRROR_HEALTH"

# Count dashboards
PRIMARY_DASHBOARDS=$(curl -s $PRIMARY_URL/api/search | jq length)
MIRROR_DASHBOARDS=$(curl -s $MIRROR_URL/api/search | jq length)

echo "Primary Dashboards: $PRIMARY_DASHBOARDS"
echo "Mirror Dashboards: $MIRROR_DASHBOARDS"
```

## Troubleshooting

### Mirror Behind Primary

**Symptoms**: Mirror missing recent dashboards

**Solutions**:
1. Check Git Sync status in mirror
2. Verify network connectivity to GitHub
3. Reduce polling interval (faster sync)
4. Check for Git conflicts

```bash
docker-compose logs grafana | grep -i "git\|sync"
```

### Dashboards Different Between Primary and Mirror

**Causes**:
- Sync lag (60s default)
- Git conflicts
- Different repository paths
- Sync disabled

**Resolution**:
1. Verify both use same repository path
2. Check last sync time in UI
3. Force sync on mirror
4. Compare dashboard UIDs

### Mirror Not Accessible

```bash
# Check container status
docker-compose ps

# Check ngrok tunnel
docker-compose logs ngrok

# Restart services
docker-compose restart
```

## Advanced Configuration

### Read-Only Mirror

Prevent changes in mirror:

```yaml
# In docker-compose.yml
environment:
  - GF_USERS_EDITORS_CAN_ADMIN=false
  - GF_USERS_ALLOW_ORG_CREATE=false
```

### Custom Sync Interval

Faster sync for critical mirrors:

```yaml
environment:
  - GF_GIT_SYNC_POLL_INTERVAL=30s  # Default: 60s
```

### Multiple Mirrors

Run multiple mirror instances:

```bash
# Mirror 1: US
NGROK_SUBDOMAIN=us-mirror.ngrok.io docker-compose up -d

# Mirror 2: EU
NGROK_SUBDOMAIN=eu-mirror.ngrok.io docker-compose -p mirror-eu up -d
```

## Best Practices

1. ✅ **Read-Only Mode**: Prevent mirror from pushing changes
2. ✅ **Regular Testing**: Periodically test failover
3. ✅ **Monitor Sync Lag**: Alert if lag exceeds threshold
4. ✅ **Document Failover**: Clear runbook for switching
5. ✅ **Health Checks**: Automated monitoring
6. ✅ **Version Matching**: Keep mirror and primary on same Grafana version

## Stopping Services

```bash
# Stop mirror
docker-compose down

# Clean slate
docker-compose down -v
```

## Next Steps

1. ✅ Set up mirror instance
2. ✅ Configure Git Sync
3. ✅ Verify synchronization
4. ✅ Test failover process
5. ✅ Implement monitoring
6. ✅ Document procedures
