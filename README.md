# Grafana Git Sync Demo Repository

A comprehensive demonstration of Grafana's Git Sync feature with 22+ dashboards across three real-world scenarios: Default setup, Dev/Prod environments, and Mirror configuration.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Grafana](https://img.shields.io/badge/Grafana-main-orange.svg)](https://github.com/grafana/grafana)

## 🎯 Overview

This repository showcases how to implement **Observability as Code** using Grafana's Git Sync feature, enabling:

- 📝 **Version control** your dashboards and folders
- 👥 **Collaborate** with team members using Git workflows
- 🔄 **Bidirectional sync** between Grafana UI and Git
- 🎨 **Visual PR previews** with before/after screenshots
- 🚀 **Automated deployments** across environments
- 🌍 **Public access** via ngrok tunnels

> ⚠️ **Note**: Git Sync is experimental as of 2025. Not recommended for production environments.

## 📦 What's Included

### 22 Dashboards Across 5 Categories

Each scenario includes a complete set of production-ready dashboards:

- **Monitoring** (5): System Overview, CPU, Memory, Disk I/O, Network
- **Applications** (5): API Performance, Database, Web Analytics, Service Health, Logs
- **Infrastructure** (5): Kubernetes, Docker, Load Balancers, Cloud Resources, Networking
- **Business** (4): Revenue, User Engagement, Sales Pipeline, KPIs
- **Security** (3): Security Overview, Access Control, Vulnerabilities

All dashboards use **Grafana Dashboard CRD format** and **TestData datasource** (no external dependencies).

## 🗂️ Repository Structure

```
campfire-using-git-sync-demo/
├── scenario-1-default/           # Standard Git Sync setup
│   ├── grafana/                  # 22 dashboards
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── scenario-2-dev-prod/          # Dev/Prod environments
│   ├── dev/grafana/              # 22 dev dashboards
│   ├── prod/grafana/             # 22 prod dashboards
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── scenario-3-mirror/            # Mirror/DR setup
│   ├── grafana/                  # 22 mirrored dashboards
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── README.md                     # This file
└── SETUP.md                      # Quick setup guide
```

## 🎬 Scenarios

### Scenario 1: Default Setup

**Perfect for**: Getting started, single-instance deployment, learning Git Sync

- Single Grafana instance with ngrok tunnel
- 22 dashboards synchronized with Git
- Image rendering for PR previews
- Bidirectional Git Sync enabled

[📖 Scenario 1 Documentation →](scenario-1-default/README.md)

### Scenario 2: Dev/Prod Environments

**Perfect for**: Multi-environment workflows, safe testing, change management

- Separate Dev and Prod instances
- Independent ngrok tunnels
- Environment-specific Git paths
- Promote dashboards from dev to prod

[📖 Scenario 2 Documentation →](scenario-2-dev-prod/README.md)

### Scenario 3: Mirror Setup

**Perfect for**: Disaster recovery, geo-distribution, high availability

- Complete mirror of dashboards
- Failover capability
- Read-only sync mode
- Geographic redundancy

[📖 Scenario 3 Documentation →](scenario-3-mirror/README.md)

## 🚀 Quick Start

### Prerequisites

- **Docker** & **Docker Compose**
- **Ngrok account** (free tier available at [ngrok.com](https://ngrok.com))
- **GitHub account** with Personal Access Token (`repo` scope)

### Choose a Scenario

**Scenario 1** (Recommended for beginners):
```bash
cd scenario-1-default
cp .env.example .env
# Edit .env with your ngrok token
docker-compose up -d
```

**Scenario 2** (Dev/Prod):
```bash
cd scenario-2-dev-prod
cp .env.example .env
# Edit .env with your ngrok tokens
docker-compose up -d
```

**Scenario 3** (Mirror):
```bash
cd scenario-3-mirror
cp .env.example .env
# Edit .env with your ngrok token
docker-compose up -d
```

### Get Your Public URL

```bash
docker-compose logs ngrok | grep "started tunnel"
# Or visit: https://dashboard.ngrok.com/endpoints
```

### Access Grafana

Open your ngrok URL (e.g., `https://your-subdomain.ngrok-free.app`)

- **Username**: `admin`
- **Password**: `admin`

### Configure Git Sync

1. In Grafana, go to **Administration** → **Git Sync**
2. Click **"Connect to GitHub"**
3. Enter configuration:
   - **Repository**: `https://github.com/MissingRoberto/campfire-using-git-sync-demo`
   - **Branch**: `main`
   - **Path**: Your scenario path (e.g., `scenario-1-default/grafana/`)
   - **PAT**: Your GitHub Personal Access Token
4. Click **"Connect"** and enable Auto Sync

## 🔧 Configuration

### Environment Variables

Each scenario uses a `.env` file:

```env
# Ngrok Configuration
NGROK_AUTHTOKEN=your_ngrok_authtoken_here
NGROK_SUBDOMAIN=your-subdomain.ngrok-free.app

# Grafana Credentials
GF_ADMIN_USER=admin
GF_ADMIN_PASSWORD=admin
```

### Feature Flags

Git Sync is enabled via environment variables in docker-compose.yml:

```yaml
GF_FEATURE_TOGGLES_ENABLE=provisioning,kubernetesDashboards
```

### Image Rendering

Each scenario includes grafana-image-renderer for PR screenshot generation:

```yaml
GF_RENDERING_SERVER_URL=http://renderer:8081/render
GF_RENDERING_CALLBACK_URL=http://grafana:3000/
```

## 📖 Documentation

- **[SETUP.md](SETUP.md)** - Quick setup guide and common commands
- **[Scenario 1 README](scenario-1-default/README.md)** - Default setup guide
- **[Scenario 2 README](scenario-2-dev-prod/README.md)** - Dev/Prod workflow
- **[Scenario 3 README](scenario-3-mirror/README.md)** - Mirror configuration

## 🎓 Git Sync Workflow

### Creating Dashboards

**Option A: In Grafana UI**
1. Create dashboard
2. Add panels and configure
3. Save → Auto-commits to Git
4. Click "Open Pull Request"

**Option B: In Git**
1. Create dashboard JSON in CRD format
2. Commit and push to repository
3. Grafana syncs within 60 seconds

### Pull Request Review

When you create a PR from Grafana:
- ✅ Automated comment with dashboard links
- ✅ Before/after screenshots
- ✅ Live preview of changes
- ✅ Merge triggers auto-sync to Grafana

### Dashboard Format

```json
{
  "apiVersion": "dashboard.grafana.app/v1beta1",
  "kind": "Dashboard",
  "metadata": {
    "name": "dashboard-uid"
  },
  "spec": {
    // Dashboard configuration
  }
}
```

## 🛠️ Common Commands

```bash
# Start scenario
docker-compose up -d

# View logs
docker-compose logs -f grafana
docker-compose logs ngrok | grep "started tunnel"

# Restart services
docker-compose restart grafana

# Stop scenario
docker-compose down

# Clean slate (removes volumes)
docker-compose down -v

# Check health
curl https://your-subdomain.ngrok-free.app/api/health
```

## 🔍 Troubleshooting

### Ngrok Tunnel Issues

```bash
# Check ngrok logs
docker-compose logs ngrok

# Verify authtoken
echo $NGROK_AUTHTOKEN

# Restart ngrok
docker-compose restart ngrok
```

### Git Sync Not Working

1. Verify GitHub PAT has `repo` permissions
2. Check repository path matches directory structure
3. Review Grafana logs: `docker-compose logs grafana | grep -i git`
4. Ensure public URL (ngrok) is accessible

### Dashboards Not Appearing

1. Check Git Sync status in Grafana UI
2. Verify dashboard CRD format is correct
3. Check polling interval (default: 60s)
4. Force sync via UI or restart: `docker-compose restart grafana`

## 📚 Resources

### Official Documentation
- [Git Sync Documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/)
- [Git Sync Setup Guide](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/git-sync-setup/)
- [Grafana Git Sync Blog](https://grafana.com/blog/2025/05/07/git-sync-grafana-12/)

### Related Projects
- [Official Git Sync Demo](https://github.com/grafana/grafana-git-sync-demo)
- [Grafana Documentation](https://grafana.com/docs/grafana/latest/)
- [Observability as Code Guide](https://devopscube.com/observability-as-code-with-grafana-git-sync/)

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add or improve dashboards/documentation
4. Submit a pull request

## 📄 License

This demo repository is provided as-is for educational purposes.

## 🙏 Acknowledgments

Inspired by the official [grafana-git-sync-demo](https://github.com/grafana/grafana-git-sync-demo) from Grafana Labs.

## 🐛 Issues & Support

- **Report Issues**: [GitHub Issues](https://github.com/MissingRoberto/campfire-using-git-sync-demo/issues)
- **Grafana Git Sync**: [Grafana Community](https://community.grafana.com/)
- **Ngrok Support**: [Ngrok Documentation](https://ngrok.com/docs)

---

**Made with ❤️ for the Grafana community**

🤖 *Generated with [Claude Code](https://claude.com/claude-code)*
