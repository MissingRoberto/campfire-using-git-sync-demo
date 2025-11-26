#!/bin/bash

# Call common setup script
../scripts/setup-git-sync.sh scenario-1-default \
    default repository.yaml

echo ""
echo "Grafana: http://localhost:3000 - syncing from scenario-1-default/grafana"
