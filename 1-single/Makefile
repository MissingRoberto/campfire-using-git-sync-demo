.PHONY: help start stop restart logs open clean setup-git-sync

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

start: ## Start all services
	@echo "Starting 1-single..."
	docker-compose --env-file ../.env up -d
	@echo "Waiting for services to be ready..."
	@sleep 5
	@echo ""
	@echo "✓ Services started!"
	@echo ""
	@echo "Access points:"
	@echo "  Local:  http://localhost:3000"
	@echo "  Ngrok:  Run 'make ngrok-url' to get public URL"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Next step (optional):"
	@echo "  make setup-git-sync  - Configure Git Sync via grafanactl"
	@echo ""
	@echo "Quick commands:"
	@echo "  make open       - Open Grafana in browser"
	@echo "  make logs       - View logs"
	@echo "  make ngrok-url  - Get ngrok public URL"

setup-git-sync: ## Configure Git Sync repository (optional)
	@echo "Configuring Git Sync..."
	@../scripts/setup-git-sync.sh 1-single default repository.yaml
	@echo ""
	@echo "Grafana: http://localhost:3000 - syncing from 1-single/grafana"

stop: ## Stop all services
	docker-compose --env-file ../.env down

restart: ## Restart all services
	docker-compose --env-file ../.env restart

logs: ## Show logs (follow mode)
	docker-compose --env-file ../.env logs -f

logs-grafana: ## Show Grafana logs only
	docker-compose --env-file ../.env logs -f grafana

logs-ngrok: ## Show ngrok logs
	docker-compose --env-file ../.env logs ngrok

ngrok-url: ## Get ngrok public URL
	@echo "Ngrok public URL:"
	@docker-compose --env-file ../.env logs ngrok 2>/dev/null | grep -o 'url=https://[^"]*' | sed 's/url=//' | tail -1 || echo "Ngrok not ready yet, try again in a few seconds"

open: ## Open Grafana in browser
	@echo "Opening Grafana..."
	@sleep 2
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "Please open http://localhost:3000 in your browser"

open-ngrok: ## Open ngrok dashboard
	@echo "Opening ngrok dashboard..."
	open https://dashboard.ngrok.com/endpoints || xdg-open https://dashboard.ngrok.com/endpoints || echo "Please open https://dashboard.ngrok.com/endpoints in your browser"

open-all: open open-ngrok ## Open all dashboards

health: ## Check health of services
	@echo "Checking service health..."
	@echo ""
	@echo "Grafana:"
	@curl -s http://localhost:3000/api/health | grep -q "ok" && echo "  ✓ Healthy" || echo "  ✗ Not responding"
	@echo ""
	@echo "Ngrok tunnel:"
	@docker-compose --env-file ../.env logs ngrok 2>/dev/null | grep -q "started tunnel" && echo "  ✓ Active" || echo "  ✗ Not active"

clean: ## Stop and remove all containers, volumes, and networks
	@echo "Cleaning up Git Sync repositories..."
	@grafanactl --config=grafanactl.yaml resources delete repositories --force 2>/dev/null || echo "No repositories to clean or Grafana not running"
	@echo "Stopping and removing containers..."
	docker-compose --env-file ../.env down -v
	@echo "All resources cleaned up"

status: ## Show status of all services
	docker-compose --env-file ../.env ps
