#!/bin/bash

# Call common setup script
../scripts/setup-git-sync.sh scenario-2-dev-prod \
    dev repository-dev.yaml \
    prod repository-prod.yaml

echo ""
echo "Dev:  http://localhost:3000 - syncing from scenario-2-dev-prod/dev"
echo "Prod: http://localhost:3001 - syncing from scenario-2-dev-prod/prod"
