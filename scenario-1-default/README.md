# Scenario 1: Default Setup

Single Grafana instance with Git Sync and 22 demo dashboards.

## Overview

- Single Grafana instance
- 22 demo dashboards across 5 folders
- Public access via ngrok
- Image rendering for PR previews

## Quick Start

### 1. Configure Environment

```bash
cp .env.example .env
# Edit .env with your ngrok token
```

### 2. Start Services

```bash
docker-compose up -d
```

### 3. Get Public URL

```bash
docker-compose logs ngrok | grep "started tunnel"
```

### 4. Access Grafana

Open your ngrok URL and login with `admin` / `admin`

## Configure Git Sync

1. Go to **Administration** → **Provisioning**
2. Click **"Configure Git Sync"**
3. Enter:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: `scenario-1-default/grafana/`
   - **Personal Access Token**: Your GitHub PAT
4. Click **"Finish"**

## Git Sync Workflow

### Create Dashboard

1. Create dashboard in Grafana
2. Save and choose:
   - "Push to main" - Direct commit
   - "Create new branch" - Create PR
3. Enter commit message

### Edit Dashboard

1. Make changes
2. Save with commit message
3. Optionally create PR for review

## Common Commands

```bash
# Start
docker-compose up -d

# Logs
docker-compose logs -f grafana

# Stop
docker-compose down

# Clean slate
docker-compose down -v
```

## Troubleshooting

### Ngrok Issues

```bash
docker-compose logs ngrok
docker-compose restart ngrok
```

### Git Sync Not Working

1. Check GitHub PAT permissions
2. Verify repository path
3. Review logs: `docker-compose logs grafana | grep -i git`

### Dashboards Not Appearing

1. Check Git Sync status in UI
2. Wait 60s for sync interval
3. Force sync via UI or restart
