# Grafana Git Sync Demo Repository

This repository demonstrates Grafana's Git Sync feature with multiple scenarios for managing dashboards as code. It includes 22+ example dashboards across various categories, showcasing how to version control, collaborate, and automate Grafana dashboard deployments.

## Overview

Git Sync enables bidirectional synchronization between Grafana dashboards and Git repositories, allowing you to:

- **Version control** your dashboards and folders
- **Review changes** through pull requests with visual previews
- **Automate deployments** across environments
- **Collaborate** with team members using familiar Git workflows
- **Maintain a single source of truth** for your observability stack

⚠️ **Important**: Git Sync is currently in experimental phase (as of 2025). While functional, it's not recommended for production or critical environments.

## Repository Structure

```
campfire-using-git-sync-demo/
├── grafana/              # Default setup - 22 dashboards
│   ├── monitoring/       # System metrics (5 dashboards)
│   ├── applications/     # Application metrics (5 dashboards)
│   ├── infrastructure/   # Infrastructure monitoring (5 dashboards)
│   ├── business/         # Business KPIs (4 dashboards)
│   └── security/         # Security metrics (3 dashboards)
├── grafana-dev/          # Development environment
├── grafana-prod/         # Production environment
├── grafana-mirror/       # Mirror setup
├── docker-compose.yml    # Multi-instance setup
└── README.md             # This file
```

## Scenarios

### Scenario 1: Default Setup (grafana/)

The default directory contains 22 dashboards organized into 5 categories:

**Monitoring (5 dashboards):**
- System Overview - High-level system health
- CPU Metrics - Detailed CPU monitoring
- Memory Metrics - Memory usage and paging
- Disk I/O - Storage performance
- Network Traffic - Network bandwidth and packets

**Applications (5 dashboards):**
- API Performance - API response times and rates
- Database Metrics - Query performance and connections
- Web Analytics - User traffic and engagement
- Service Health - Uptime and health checks
- Application Logs - Log volume and error trends

**Infrastructure (5 dashboards):**
- Kubernetes Cluster - K8s resources and pods
- Docker Containers - Container metrics
- Load Balancers - Request distribution
- Cloud Resources - Cloud costs and usage
- Networking - Latency and DNS

**Business (4 dashboards):**
- Revenue Metrics - Sales and transactions
- User Engagement - DAU/MAU and retention
- Sales Pipeline - Leads and conversions
- KPI Overview - Key business metrics

**Security (3 dashboards):**
- Security Overview - Threats and incidents
- Access Control - Sessions and permissions
- Vulnerability Scan - CVE tracking

### Scenario 2: Dev/Prod Setup

Separate Grafana instances for development and production environments:

- **grafana-dev/** - Development dashboards (port 3001)
- **grafana-prod/** - Production dashboards (port 3002)

This setup allows you to:
- Test dashboard changes in dev before promoting to prod
- Maintain environment-specific configurations
- Use Git branches for environment isolation

### Scenario 3: Mirror Setup

The **grafana-mirror/** directory demonstrates a complete mirror of all dashboards, useful for:
- Disaster recovery
- Geographic distribution
- Load balancing across instances

## Dashboard Format

All dashboards use the Grafana Dashboard CRD format for Git Sync:

```json
{
  "apiVersion": "dashboard.grafana.app/v1beta1",
  "kind": "Dashboard",
  "metadata": {
    "name": "dashboard-uid"
  },
  "spec": {
    // Dashboard JSON definition
  }
}
```

## Data Sources

All dashboards use the **TestData** datasource (`uid: "-- Grafana --"`), which is built into Grafana and requires no external configuration. This makes the demo self-contained and immediately functional.

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git
- A GitHub account (for Git Sync setup)

### Running Locally

1. **Clone this repository:**
   ```bash
   git clone <your-repo-url>
   cd campfire-using-git-sync-demo
   ```

2. **Start Grafana instances:**
   ```bash
   docker-compose up -d
   ```

3. **Access the instances:**
   - Default: http://localhost:3000
   - Dev: http://localhost:3001
   - Prod: http://localhost:3002
   - Mirror: http://localhost:3003

4. **Login credentials:**
   - Username: `admin`
   - Password: `admin`

### Setting Up Git Sync

1. **In Grafana UI:**
   - Navigate to Administration → Git Sync
   - Click "Connect to GitHub"
   - Authorize Grafana to access your GitHub account

2. **Configure Repository:**
   - Repository URL: Your forked repository
   - Branch: `main`
   - Path: `grafana/` (or `grafana-dev/`, `grafana-prod/`, `grafana-mirror/`)

3. **Personal Access Token:**
   - Create a GitHub PAT with `repo` scope
   - Add it to Grafana Git Sync configuration

4. **Enable Synchronization:**
   - Set polling interval (default: 60 seconds)
   - Optionally configure webhooks for faster sync (5 seconds)

## Usage Workflows

### Creating a New Dashboard

1. **Option A: Via Grafana UI**
   - Create dashboard in Grafana
   - Save it
   - Git Sync automatically commits to repository
   - Open pull request from Grafana UI

2. **Option B: Via Git**
   - Create dashboard JSON file following CRD format
   - Commit and push to repository
   - Grafana syncs within polling interval

### Editing Dashboards

1. **Edit in Grafana:**
   - Make changes in UI
   - Save dashboard
   - Submit pull request directly from Grafana

2. **Edit in Git:**
   - Modify JSON file
   - Commit changes
   - Grafana pulls updates automatically

### Pull Request Workflow

When you create a PR from Grafana:
- Grafana adds a comment with links
- Preview of the edited dashboard
- Screenshot of changes
- Link to original dashboard

## Git Sync Features

### Bidirectional Sync
- Changes in Grafana → Git commits
- Changes in Git → Grafana updates

### Pull Request Integration
- Create PRs from Grafana UI
- Automatic dashboard previews
- Visual diff screenshots

### Folder Organization
- Dashboards organized in folders
- Folder structure preserved in Git
- Easy to navigate and maintain

### Collaborative Workflows
- Team members can review changes
- Track dashboard evolution over time
- Rollback to previous versions

## Best Practices

1. **Use Descriptive Commit Messages**: When making changes, provide clear commit messages explaining what changed and why

2. **Branch Strategy**:
   - Use feature branches for new dashboards
   - Use environment branches (dev/staging/prod) for promotions
   - Always review changes via pull requests

3. **Dashboard Organization**:
   - Group related dashboards in folders
   - Use consistent naming conventions
   - Tag dashboards appropriately

4. **Testing**:
   - Test dashboard changes in dev environment first
   - Verify data source compatibility
   - Check panel queries and visualizations

5. **Version Control**:
   - Commit small, atomic changes
   - Document breaking changes
   - Use semantic versioning for major updates

## Limitations

Current Git Sync limitations (as of 2025):

- ✅ Dashboards and folders supported
- ❌ Data sources not synced
- ❌ Alerts not synced
- ❌ Panels and plugins not synced
- ❌ Full-instance sync not available

## Documentation Resources

- [Git Sync Documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/)
- [Git Sync Setup Guide](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/git-sync-setup/)
- [Git Sync Blog Post](https://grafana.com/blog/2025/05/07/git-sync-grafana-12/)
- [Official Demo Repository](https://github.com/grafana/grafana-git-sync-demo)
- [Observability as Code](https://devopscube.com/observability-as-code-with-grafana-git-sync/)

## Troubleshooting

### Dashboards Not Appearing

1. Check Git Sync status in Grafana UI
2. Verify repository path and branch
3. Check Grafana logs: `docker logs grafana-default`
4. Ensure CRD format is correct

### Sync Not Working

1. Verify GitHub PAT has correct permissions
2. Check polling interval settings
3. Configure webhooks for faster sync
4. Review Git Sync connection status

### Permission Issues

1. Ensure PAT has `repo` scope
2. Verify repository access
3. Check Grafana user permissions

## Contributing

Feel free to contribute additional dashboard examples or improvements:

1. Fork this repository
2. Create a feature branch
3. Add your dashboards following the CRD format
4. Submit a pull request

## License

This demo repository is provided as-is for educational and demonstration purposes.

## Acknowledgments

This demo is inspired by the official [grafana-git-sync-demo](https://github.com/grafana/grafana-git-sync-demo) repository from Grafana Labs.
