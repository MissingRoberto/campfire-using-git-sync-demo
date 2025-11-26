#!/bin/bash

# Common Git Sync setup script
# Usage: ./scripts/setup-git-sync.sh <scenario-dir> <context1> <repo-file1> [<context2> <repo-file2> ...]
#
# Example: ./scripts/setup-git-sync.sh scenario-2-dev-prod dev repository-dev.yaml prod repository-prod.yaml

set -e

SCENARIO_DIR=$1
shift

# Load environment variables
if [ ! -f "../.env" ]; then
    echo "Error: ../.env file not found"
    echo "Please copy .env.example to .env and configure it"
    exit 1
fi

source ../.env

# Check required variables
if [ -z "$GITHUB_PAT" ] || [ -z "$GITHUB_REPO" ] || [ -z "$GITHUB_BRANCH" ]; then
    echo "Error: GITHUB_PAT, GITHUB_REPO, and GITHUB_BRANCH must be set in .env file"
    exit 1
fi

# Export variables for envsubst
export GITHUB_PAT
export GITHUB_REPO
export GITHUB_BRANCH

echo "Setting up Git Sync for $SCENARIO_DIR..."

# Wait for Grafana instances to be ready
echo "Waiting for Grafana instances to be ready..."
TIMEOUT=60
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    ALL_READY=true

    # Check common ports
    for port in 3000 3001 8080; do
        if netstat -an 2>/dev/null | grep -q ":$port.*LISTEN" || lsof -i :$port 2>/dev/null | grep -q LISTEN; then
            if ! curl -s http://localhost:$port/api/health > /dev/null 2>&1; then
                ALL_READY=false
            fi
        fi
    done

    if [ "$ALL_READY" = true ]; then
        echo "Grafana instances are ready!"
        break
    fi

    if [ $ELAPSED -ge $TIMEOUT ]; then
        echo "Timeout waiting for Grafana instances"
        exit 1
    fi

    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

# Process each context/repository pair
while [ $# -gt 0 ]; do
    CONTEXT=$1
    REPO_FILE=$2

    if [ -z "$CONTEXT" ] || [ -z "$REPO_FILE" ]; then
        echo "Error: Invalid context/repo-file pair"
        exit 1
    fi

    echo "Configuring Git Sync for context: $CONTEXT"

    # Switch to context
    grafanactl --config=grafanactl.yaml config use-context $CONTEXT

    # Create temporary directory with proper file naming
    TEMP_DIR=$(mktemp -d)
    REPO_NAME=$(basename $REPO_FILE .yaml)
    envsubst < $REPO_FILE > $TEMP_DIR/${REPO_NAME}.yaml

    # Push repository configuration
    grafanactl --config=grafanactl.yaml resources push --path $TEMP_DIR

    # Clean up
    rm -rf $TEMP_DIR

    shift 2
done

echo ""
echo "Git Sync setup complete!"
