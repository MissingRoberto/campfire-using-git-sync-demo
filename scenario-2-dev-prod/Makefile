.PHONY: help start stop restart logs open clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

start: ## Start all services (dev + prod)
	@echo "Starting scenario-2-dev-prod..."
	docker-compose up -d
	@echo "Waiting for services to be ready..."
	@sleep 5
	@echo ""
	@echo "✓ Services started!"
	@echo ""
	@echo "Access points:"
	@echo "  Dev (local):  http://localhost:3000"
	@echo "  Prod (local): http://localhost:3001"
	@echo "  Prod (ngrok): Run 'make ngrok-url' to get public URL"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Workflow:"
	@echo "  1. Edit dashboard in Dev (port 3000)"
	@echo "  2. Promote to Prod: make promote"
	@echo "  3. Verify in Prod (port 3001 or ngrok URL)"
	@echo ""
	@echo "Quick commands:"
	@echo "  make open-dev   - Open Dev Grafana"
	@echo "  make open-prod  - Open Prod Grafana"
	@echo "  make open-all   - Open both + ngrok dashboard"
	@echo "  make promote    - Promote dev dashboard to prod"

stop: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

restart-dev: ## Restart dev only
	docker-compose restart grafana-dev

restart-prod: ## Restart prod only
	docker-compose restart grafana-prod

logs: ## Show logs (all services)
	docker-compose logs -f

logs-dev: ## Show dev Grafana logs
	docker-compose logs -f grafana-dev

logs-prod: ## Show prod Grafana logs
	docker-compose logs -f grafana-prod

logs-ngrok: ## Show ngrok logs
	docker-compose logs ngrok

ngrok-url: ## Get ngrok public URL (points to prod)
	@echo "Ngrok public URL (Prod):"
	@docker-compose logs ngrok 2>/dev/null | grep -o 'url=https://[^"]*' | sed 's/url=//' | tail -1 || echo "Ngrok not ready yet, try again in a few seconds"

open-dev: ## Open Dev Grafana in browser
	@echo "Opening Dev Grafana..."
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "Please open http://localhost:3000 in your browser"

open-prod: ## Open Prod Grafana in browser
	@echo "Opening Prod Grafana..."
	open http://localhost:3001 || xdg-open http://localhost:3001 || echo "Please open http://localhost:3001 in your browser"

open-ngrok: ## Open ngrok dashboard
	@echo "Opening ngrok dashboard..."
	open https://dashboard.ngrok.com/endpoints || xdg-open https://dashboard.ngrok.com/endpoints || echo "Please open https://dashboard.ngrok.com/endpoints in your browser"

open-all: open-dev open-prod open-ngrok ## Open all dashboards

promote: ## Promote dev dashboard to prod
	@echo "Promoting dashboard from dev to prod..."
	@if [ ! -f dev/new-dashboard.json ]; then \
		echo "Error: dev/new-dashboard.json not found"; \
		exit 1; \
	fi
	@mkdir -p prod
	@cp dev/new-dashboard.json prod/new-dashboard.json
	@echo "✓ Dashboard copied to prod/"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Commit changes: git add prod/new-dashboard.json && git commit -m 'Promote dashboard to prod' && git push"
	@echo "  2. Wait for Git Sync (60s) or force sync in Prod Grafana UI"
	@echo "  3. Verify in Prod: make open-prod"

health: ## Check health of services
	@echo "Checking service health..."
	@echo ""
	@echo "Dev Grafana:"
	@curl -s http://localhost:3000/api/health | grep -q "ok" && echo "  ✓ Healthy" || echo "  ✗ Not responding"
	@echo ""
	@echo "Prod Grafana:"
	@curl -s http://localhost:3001/api/health | grep -q "ok" && echo "  ✓ Healthy" || echo "  ✗ Not responding"
	@echo ""
	@echo "Ngrok tunnel:"
	@docker-compose logs ngrok 2>/dev/null | grep -q "started tunnel" && echo "  ✓ Active" || echo "  ✗ Not active"

clean: ## Stop and remove all containers, volumes, and networks
	docker-compose down -v
	@echo "All resources cleaned up"

status: ## Show status of all services
	docker-compose ps
