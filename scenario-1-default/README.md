# Scenario 1: Default Setup

This scenario demonstrates the standard Grafana Git Sync setup with 22 dashboards organized into 5 categories.

## Overview

- **Dashboards**: 22 total across 5 folders
- **Public Access**: Via ngrok tunnel
- **Image Rendering**: Enabled for PR previews
- **Git Sync**: Bidirectional sync with GitHub

## Directory Structure

```
scenario-1-default/
├── grafana/              # 22 dashboards
│   ├── monitoring/       # 5 system monitoring dashboards
│   ├── applications/     # 5 application metrics dashboards
│   ├── infrastructure/   # 5 infrastructure dashboards
│   ├── business/         # 4 business KPI dashboards
│   └── security/         # 3 security monitoring dashboards
├── docker-compose.yml
├── .env.example
└── README.md
```

## Prerequisites

1. **Docker & Docker Compose** installed
2. **Ngrok account** - Sign up at https://ngrok.com
3. **GitHub account** - For Git Sync integration
4. **GitHub Personal Access Token** - With `repo` scope

## Quick Start

### 1. Setup Ngrok

```bash
# Get your ngrok authtoken from: https://dashboard.ngrok.com/get-started/your-authtoken
```

### 2. Configure Environment

```bash
# Copy example env file
cp .env.example .env

# Edit .env with your values
nano .env
```

Required values:
```env
NGROK_AUTHTOKEN=your_actual_ngrok_token
NGROK_SUBDOMAIN=your-subdomain.ngrok-free.app  # Free tier gets random subdomain
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=admin
```

### 3. Start Services

```bash
docker-compose up -d
```

### 4. Get Your Public URL

```bash
# Check ngrok URL
docker-compose logs ngrok | grep "started tunnel"

# Or visit the ngrok dashboard
open https://dashboard.ngrok.com/endpoints
```

### 5. Access Grafana

Open your ngrok URL (e.g., `https://your-subdomain.ngrok-free.app`) and login with:
- **Username**: `admin` (or value from .env)
- **Password**: `admin` (or value from .env)

## Setting Up Git Sync

### 1. Create GitHub Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scopes:
   - ✅ `repo` (Full control of private repositories)
4. Copy the token

### 2. Configure Git Sync in Grafana

1. In Grafana, navigate to **Administration** → **Plugins and data** → **Plugins**
2. Search for "Git" or go to **Administration** → **Git Sync** (if visible in menu)
3. Click **"Connect to GitHub"**
4. Enter:
   - **Repository URL**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-1-default/grafana/`
   - **Personal Access Token**: Your GitHub PAT
5. Click **"Connect"**

### 3. Configure Synchronization

1. Set **Polling Interval**: 60 seconds (default)
2. Enable **"Auto Sync"** for automatic synchronization
3. (Optional) Configure **Webhooks** for faster sync (5 seconds):
   - In GitHub, go to repository Settings → Webhooks
   - Add webhook: `https://your-subdomain.ngrok-free.app/api/git-sync/webhook`
   - Content type: `application/json`
   - Events: Select "Pull requests" and "Pushes"

## Using Git Sync

### Creating a New Dashboard

1. **In Grafana UI**:
   - Create a new dashboard
   - Add panels and configure
   - Save the dashboard
   - Git Sync automatically commits to GitHub
   - Click "Open Pull Request" button to create PR

2. **In GitHub**:
   - Create new dashboard JSON file in `grafana/` folder
   - Commit and push
   - Grafana syncs within polling interval

### Editing Dashboards

1. **Via Grafana**:
   - Edit dashboard
   - Save changes
   - Submit pull request directly from Grafana
   - Grafana adds PR comment with preview and screenshot

2. **Via Git**:
   - Edit dashboard JSON in repository
   - Commit and push changes
   - Grafana pulls updates automatically

### Pull Request Workflow

When you create a PR from Grafana:
- ✅ Grafana adds a comment with links
- ✅ Preview of the edited dashboard
- ✅ Screenshot comparing before/after
- ✅ Link to original dashboard

## Dashboard Categories

### Monitoring (5 dashboards)
- **System Overview** - High-level system health metrics
- **CPU Metrics** - Per-core CPU usage, load average, context switches
- **Memory Metrics** - Memory usage, swap, cache, buffers
- **Disk I/O** - Disk throughput, IOPS, latency
- **Network Traffic** - Bandwidth, packets, errors

### Applications (5 dashboards)
- **API Performance** - Response times, request rates, error rates
- **Database Metrics** - Query duration, connections, transactions
- **Web Analytics** - Users, page views, bounce rate, sessions
- **Service Health** - Uptime, health checks, dependencies
- **Application Logs** - Log volume, error trends

### Infrastructure (5 dashboards)
- **Kubernetes Cluster** - Node status, pods, resource utilization
- **Docker Containers** - Container metrics, CPU, memory, restarts
- **Load Balancers** - Request distribution, backend health
- **Cloud Resources** - Cloud costs, resource usage, service limits
- **Networking** - Latency, packet loss, DNS queries

### Business (4 dashboards)
- **Revenue Metrics** - Daily revenue, transactions, AOV, conversion
- **User Engagement** - DAU/MAU, retention, feature usage
- **Sales Pipeline** - Leads, opportunities, win rate
- **KPI Overview** - Key metrics, targets vs actuals

### Security (3 dashboards)
- **Security Overview** - Failed logins, threats, incidents
- **Access Control** - User sessions, permissions, API keys
- **Vulnerability Scan** - CVE count, patch status, compliance

## Troubleshooting

### Ngrok Tunnel Not Starting

```bash
# Check ngrok logs
docker-compose logs ngrok

# Verify authtoken
echo $NGROK_AUTHTOKEN

# Restart ngrok
docker-compose restart ngrok
```

### Dashboards Not Syncing

1. Check Git Sync status in Grafana UI
2. Verify GitHub PAT permissions
3. Check repository path matches: `scenario-1-default/grafana/`
4. Review Grafana logs:
   ```bash
   docker-compose logs grafana | grep -i "git"
   ```

### Image Rendering Issues

```bash
# Check renderer status
docker-compose logs renderer

# Restart renderer
docker-compose restart renderer
```

### Cannot Access via Ngrok URL

1. Verify ngrok tunnel is active: `docker-compose logs ngrok`
2. Check GF_SERVER_ROOT_URL matches ngrok URL
3. Ensure no firewall blocking ngrok
4. Try browser incognito mode (clears cache)

## Stopping Services

```bash
# Stop all containers
docker-compose down

# Stop and remove volumes (clean slate)
docker-compose down -v
```

## Notes

- **TestData Datasource**: All dashboards use built-in TestData source
- **Grafana Main Image**: Uses `grafana/grafana:main` for latest Git Sync features
- **Feature Flags**: Git Sync enabled via `GF_FEATURE_TOGGLES_ENABLE`
- **Public URL**: Required for GitHub webhooks and PR previews

## Next Steps

1. ✅ Explore the pre-built dashboards
2. ✅ Test Git Sync by making changes
3. ✅ Create a pull request from Grafana
4. ✅ Review PR with dashboard preview
5. ✅ Customize dashboards for your needs
