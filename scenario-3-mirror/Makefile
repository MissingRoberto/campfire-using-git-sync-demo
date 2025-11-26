.PHONY: help start stop restart logs open clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

start: ## Start all services (primary + mirror)
	@echo "Starting scenario-3-mirror..."
	docker-compose up -d
	@echo "Waiting for services to be ready..."
	@sleep 5
	@echo ""
	@echo "✓ Services started!"
	@echo ""
	@echo "Access points:"
	@echo "  Primary (local): http://localhost:3000"
	@echo "  Mirror (local):  http://localhost:3001"
	@echo "  Primary (ngrok): Run 'make ngrok-url' to get public URL"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Both instances sync from: scenario-3-mirror/grafana/"
	@echo ""
	@echo "Quick commands:"
	@echo "  make open-primary  - Open Primary Grafana"
	@echo "  make open-mirror   - Open Mirror Grafana"
	@echo "  make open-all      - Open both + ngrok dashboard"
	@echo "  make failover      - Switch ngrok to mirror"

stop: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

restart-primary: ## Restart primary only
	docker-compose restart grafana-primary

restart-mirror: ## Restart mirror only
	docker-compose restart grafana-mirror

logs: ## Show logs (all services)
	docker-compose logs -f

logs-primary: ## Show primary Grafana logs
	docker-compose logs -f grafana-primary

logs-mirror: ## Show mirror Grafana logs
	docker-compose logs -f grafana-mirror

logs-ngrok: ## Show ngrok logs
	docker-compose logs ngrok

ngrok-url: ## Get ngrok public URL (points to primary)
	@echo "Ngrok public URL (Primary):"
	@docker-compose logs ngrok 2>/dev/null | grep -o 'url=https://[^"]*' | sed 's/url=//' | tail -1 || echo "Ngrok not ready yet, try again in a few seconds"

open-primary: ## Open Primary Grafana in browser
	@echo "Opening Primary Grafana..."
	open http://localhost:3000 || xdg-open http://localhost:3000 || echo "Please open http://localhost:3000 in your browser"

open-mirror: ## Open Mirror Grafana in browser
	@echo "Opening Mirror Grafana..."
	open http://localhost:3001 || xdg-open http://localhost:3001 || echo "Please open http://localhost:3001 in your browser"

open-ngrok: ## Open ngrok dashboard
	@echo "Opening ngrok dashboard..."
	open https://dashboard.ngrok.com/endpoints || xdg-open https://dashboard.ngrok.com/endpoints || echo "Please open https://dashboard.ngrok.com/endpoints in your browser"

open-all: open-primary open-mirror open-ngrok ## Open all dashboards

failover: ## Switch ngrok tunnel to mirror (disaster recovery)
	@echo "Initiating failover to mirror..."
	@echo ""
	@echo "Manual steps required:"
	@echo "  1. Edit docker-compose.yml"
	@echo "  2. Change ngrok command from 'grafana-primary:3000' to 'grafana-mirror:3000'"
	@echo "  3. Run: make restart-ngrok"
	@echo ""
	@echo "Or run this command:"
	@echo "  sed -i.bak 's/grafana-primary:3000/grafana-mirror:3000/' docker-compose.yml && make restart-ngrok"

restart-ngrok: ## Restart ngrok tunnel
	docker-compose restart ngrok
	@echo "Ngrok restarted. New URL:"
	@sleep 2
	@make ngrok-url

health: ## Check health of services
	@echo "Checking service health..."
	@echo ""
	@echo "Primary Grafana:"
	@curl -s http://localhost:3000/api/health | grep -q "ok" && echo "  ✓ Healthy" || echo "  ✗ Not responding"
	@echo ""
	@echo "Mirror Grafana:"
	@curl -s http://localhost:3001/api/health | grep -q "ok" && echo "  ✓ Healthy" || echo "  ✗ Not responding"
	@echo ""
	@echo "Ngrok tunnel:"
	@docker-compose logs ngrok 2>/dev/null | grep -q "started tunnel" && echo "  ✓ Active" || echo "  ✗ Not active"

clean: ## Stop and remove all containers, volumes, and networks
	docker-compose down -v
	@echo "All resources cleaned up"

status: ## Show status of all services
	docker-compose ps
