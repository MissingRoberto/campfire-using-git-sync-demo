# Grafana Git Sync UI Complete Guide

This guide provides the correct navigation paths and workflows for using Git Sync in Grafana v12 (experimental).

## Table of Contents
- [Accessing Git Sync](#accessing-git-sync)
- [Setting Up Git Sync](#setting-up-git-sync)
- [Managing Dashboards](#managing-dashboards)
- [Creating Pull Requests](#creating-pull-requests)
- [UI Pages Reference](#ui-pages-reference)

---

## Accessing Git Sync

### Primary Navigation Path

**Administration → Provisioning**

This is the central hub for all Git Sync operations in Grafana.

---

## Setting Up Git Sync

### Step 1: Navigate to Provisioning

1. Click **Administration** in the left sidebar
2. Select **Provisioning**
3. Click **Configure Git Sync** button

### Step 2: Connect to External Storage

You'll need to provide:

- **Personal Access Token**: Your GitHub PAT with permissions for:
  - Contents (read/write)
  - Metadata (read)
  - Pull Requests (read/write)
  - Webhooks (read/write)
- **Repository URL**: Full GitHub repository URL (e.g., `https://github.com/MissingRoberto/campfire-using-git-sync-demo`)
- **Branch**: Branch name (default: `main`)
- **Path**: Subdirectory for dashboards (e.g., `scenario-1-default/grafana/`)

### Step 3: Choose What to Synchronize

Select synchronization type:

- **"Sync all resources with external storage"** - Manages entire Grafana instance through one repository
- **"Sync external storage to new Grafana folder"** - Syncs resources into a new folder (supports up to 10 connections)

### Step 4: Configure Settings

- **Display Name**: Name for this repository connection
- **Update Interval**: Polling interval in seconds (default: 60)
- **Read Only**: Enable to prevent pushing changes back to Git
- **Dashboard Previews**: Enable if image renderer is configured
- Click **Finish** to complete setup

### Step 5: Verify Connection

1. Navigate to **Dashboards** in the main menu
2. Confirm synced dashboards appear
3. Provisioned folders will have a "Provisioned" label

---

## Managing Dashboards

### Viewing Sync Status

**Path**: `Administration → Provisioning → View` (click View button next to repository)

This page shows:
- **Sync Status**: Up-to-date, syncing, failed
- **Resource Summary**: Number of dashboards, folders
- **Health Status**: Repository connection health
- **Webhook Info**: Webhook configuration status
- **Sync Jobs**: History of sync operations
- **Events Tab**: Detailed sync logs

### Manual Sync

**Path**: `Administration → Provisioning`

Click the **Pull** button next to your repository to manually trigger synchronization.

### Dashboard Indicators

Dashboards managed by Git Sync show:
- Purple **<->** badge indicating Git Sync management
- "Provisioned" label on folders
- Special save dialog with Git workflow options

---

## Creating and Editing Dashboards

### Creating a New Dashboard

1. Navigate to **Dashboards** → **New** → **New Dashboard**
2. Add visualizations and configure panels
3. Click **Save** (disk icon in top-right)

### Save Dialog for Git Sync Dashboards

When saving a provisioned dashboard, you'll see:

**Dashboard Settings:**
- **Title**: Dashboard name
- **Folder**: Select provisioned folder (created by Git Sync)
- **Description**: Optional description

**Git Sync Options:**
- **Path**: Repository file path (must end in .json)
- **Workflow**: Choose one:
  - **Push to main**: Commit directly to main branch
  - **Create new branch**: Create feature branch for PR workflow
- **Branch**: Branch name (if creating new branch)
- **Comment**: Commit message describing changes

**Preview:**
- **Changes tab**: Shows diff preview before saving

**Actions:**
- Click **Save** to commit changes

---

## Creating Pull Requests

### Workflow: Edit → Branch → PR

1. **Edit Dashboard**:
   - Open dashboard in edit mode
   - Make your changes
   - Click Save

2. **Choose "Create new branch"**:
   - Select "Create new branch" in Workflow dropdown
   - Enter branch name (e.g., `feature/update-cpu-dashboard`)
   - Add commit message in Comment field
   - Click Save

3. **Open Pull Request**:
   - A banner appears with **"Open Pull Request"** button
   - Click button to open GitHub in new tab
   - GitHub PR form is pre-filled
   - Grafana automatically adds comment with:
     - Link to original dashboard
     - Dashboard preview
     - Before/after screenshots

4. **Review**:
   - Team members review PR in GitHub
   - Preview dashboard changes via Grafana comment
   - Approve or request changes

5. **Merge**:
   - Merge PR in GitHub
   - Grafana syncs changes within polling interval (default: 60s)
   - Or click Pull button for immediate sync

---

## UI Pages Reference

### 1. Administration → Provisioning (Main Hub)

**What it does**: Central management for all Git Sync repositories

**Actions available**:
- Configure new Git Sync connection
- View repository status and sync history
- Pull (manual sync)
- Delete repository connection

**Key elements**:
- Repository list with status indicators
- Pull button (manual sync trigger)
- View link (detailed status)
- Trashcan icon (delete repository)

---

### 2. Repository View Page

**Path**: `Administration → Provisioning → View`

**What it shows**:
- Sync status (Up-to-date / Syncing / Failed)
- Resource count (dashboards, folders)
- Health indicators
- Webhook configuration
- Sync job history
- Event logs

**Status indicators**:
- Green "Up-to-date" label
- Yellow "Syncing" label
- Red "Failed" label with error details

---

### 3. Managed Dashboards

**Path**: `Dashboards` (main menu)

**Identifying managed dashboards**:
- Purple **<->** badge next to dashboard name
- Listed under provisioned folders
- "Provisioned" label on folder names

**Restrictions**:
- Cannot be deleted from UI (delete from Git)
- Save behavior follows Git workflow
- May have read-only restrictions if configured

---

### 4. Dashboard Editor with Git Sync

**Path**: `Dashboards → [Dashboard] → Edit`

**Git-specific fields**:
- **Folder**: Must select provisioned folder
- **Path**: File path in repository (ends with .json)
- **Workflow**: Push to main OR Create new branch
- **Branch**: Branch name for new branch workflow
- **Comment**: Commit message

**Additional features**:
- **Changes tab**: Preview diff before saving
- **"Open Pull Request"** button after branch save

---

### 5. Dashboard Export Options

**Path**: `Dashboards → [Dashboard] → Share/Export dropdown`

**Export options**:

1. **Export as JSON**
   - Download dashboard JSON
   - Copy to clipboard
   - Option: "Export for sharing externally"

2. **Export as PDF** (Enterprise/Cloud only)
   - Configure orientation
   - Set layout (Grid/Simple)
   - Adjust zoom level
   - Generate and download PDF

3. **Export as Image** (requires image renderer)
   - Generate dashboard screenshot
   - Download image file

**Note**: Exporting doesn't affect Git Sync, it's for manual backup/sharing.

---

### 6. Events and Sync Logs

**Path**: `Administration → Provisioning → [Repository] → Events Tab`

**What it shows**:
- Timestamp of sync operations
- Sync results (success/failure)
- Error messages and details
- Resources affected by each sync
- Webhook trigger events

---

### 7. File Provisioning (Alternative)

**Path**: `Administration → Provisioning → Configure File Provisioning`

**What it does**: Alternative to Git Sync using local file paths instead of Git repositories.

**Use case**: When you want file-based provisioning without Git integration.

---

## Common Workflows

### Workflow 1: Direct Commit to Main

```
Edit Dashboard → Save → Choose "Push to main" → Enter comment → Save
                                                                   ↓
                                                         Changes in GitHub
```

Best for: Small changes, fixes, trusted contributors

### Workflow 2: Pull Request Review

```
Edit Dashboard → Save → Choose "Create new branch" → Enter branch name
                                                                   ↓
                                            Save → Click "Open Pull Request"
                                                                   ↓
                                    GitHub PR created with preview → Review
                                                                   ↓
                                              Merge PR → Grafana syncs
```

Best for: Major changes, team review, multiple stakeholders

### Workflow 3: Git-First Editing

```
Edit JSON in GitHub → Commit → Push
                                  ↓
                    Wait for polling interval (60s)
                                  ↓
                    Or click Pull in Grafana
                                  ↓
                    Changes appear in Grafana
```

Best for: Bulk updates, scripted changes, advanced users

---

## Troubleshooting

### Dashboard Not Syncing

1. Check sync status: `Administration → Provisioning → View`
2. Review Events tab for errors
3. Verify GitHub PAT permissions
4. Check repository path matches folder structure
5. Click Pull button to force sync

### Cannot Save Dashboard

- Verify you're in a provisioned folder
- Check Path field ends with .json
- Ensure you have write permissions
- Verify repository connection is active

### Pull Request Not Creating

- Confirm "Create new branch" workflow selected
- Check branch name is valid
- Verify GitHub PAT has PR permissions
- Look for error messages in save dialog

### Preview/Screenshots Missing

- Verify image renderer is running
- Check rendering service URL in config
- Confirm GF_RENDERING_SERVER_URL is set
- Test renderer health: `http://renderer:8081/render`

---

## Best Practices

1. **Use Pull Requests**: For team environments, use "Create new branch" workflow
2. **Descriptive Comments**: Always add clear commit messages
3. **Regular Syncs**: If using push workflow, monitor sync status
4. **Webhook Setup**: Configure webhooks for faster sync (5s vs 60s)
5. **Read-Only Mode**: Use for mirror instances to prevent conflicts
6. **Folder Structure**: Organize dashboards in logical folder hierarchy
7. **Test in Dev**: Test major changes in dev environment first

---

## References

- [Git Sync Documentation](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/intro-git-sync/)
- [Set up Git Sync](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/git-sync-setup/)
- [Manage Provisioned Repositories](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/use-git-sync/)
- [Work with Provisioned Dashboards](https://grafana.com/docs/grafana/latest/as-code/observability-as-code/provision-resources/provisioned-dashboards/)
