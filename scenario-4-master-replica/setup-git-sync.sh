#!/bin/bash

# Call common setup script
../scripts/setup-git-sync.sh scenario-4-master-replica \
    master repository-master.yaml \
    replica repository-replica.yaml

echo ""
echo "Master:  http://localhost:3000 - syncing from scenario-4-master-replica/shared"
echo "Replica: http://localhost:3001 - syncing from scenario-4-master-replica/shared"
echo "Load Balancer: http://localhost:8080"
