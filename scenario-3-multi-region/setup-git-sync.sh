#!/bin/bash

# Call common setup script
../scripts/setup-git-sync.sh scenario-3-multi-region \
    us repository-us.yaml \
    eu repository-eu.yaml

echo ""
echo "US Region: http://localhost:3000 - syncing from scenario-3-multi-region/shared"
echo "EU Region: http://localhost:3001 - syncing from scenario-3-multi-region/shared"
