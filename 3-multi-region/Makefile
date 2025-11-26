.PHONY: help start stop restart logs logs-us logs-eu status health open open-us open-eu open-all ngrok-url clean setup-git-sync

help:
	@echo "Available commands:"
	@echo "  make start           - Start both US and EU Grafana instances"
	@echo "  make setup-git-sync  - Configure Git Sync for both regions"
	@echo "  make stop            - Stop all services"
	@echo "  make restart         - Restart all services"
	@echo "  make logs            - View logs from all services"
	@echo "  make logs-us         - View logs from US region"
	@echo "  make logs-eu         - View logs from EU region"
	@echo "  make status          - Show container status"
	@echo "  make health          - Check health of all services"
	@echo "  make open            - Open both Grafana instances in browser"
	@echo "  make open-us         - Open US region Grafana"
	@echo "  make open-eu         - Open EU region Grafana"
	@echo "  make open-all        - Open both instances + ngrok dashboard"
	@echo "  make ngrok-url       - Get public ngrok URL"
	@echo "  make clean           - Stop and remove all containers and volumes"

start:
	docker-compose --env-file ../.env up -d
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@echo ""
	@echo "Services started!"
	@echo "US Region: http://localhost:3000"
	@echo "EU Region: http://localhost:3001"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Next step:"
	@echo "  make setup-git-sync   - Configure Git Sync for both regions"
	@echo ""
	@echo "Get public URL: make ngrok-url"

setup-git-sync: ## Configure Git Sync repositories for US and EU regions
	@echo "Configuring Git Sync..."
	@../scripts/setup-git-sync.sh 3-multi-region us repository-us.yaml eu repository-eu.yaml
	@echo ""
	@echo "US Region: http://localhost:3000 - syncing from 3-multi-region/shared"
	@echo "EU Region: http://localhost:3001 - syncing from 3-multi-region/shared"

stop:
	docker-compose --env-file ../.env down

restart: stop start

logs:
	docker-compose --env-file ../.env logs -f

logs-us:
	docker-compose --env-file ../.env logs -f grafana-us

logs-eu:
	docker-compose --env-file ../.env logs -f grafana-eu

status:
	docker-compose --env-file ../.env ps

health:
	@echo "Checking service health..."
	@docker-compose --env-file ../.env ps
	@echo ""
	@echo "US Region Health:"
	@curl -s http://localhost:3000/api/health | grep -q "ok" && echo "✓ US Region is healthy" || echo "✗ US Region is not responding"
	@echo "EU Region Health:"
	@curl -s http://localhost:3001/api/health | grep -q "ok" && echo "✓ EU Region is healthy" || echo "✗ EU Region is not responding"

open:
	@echo "Opening both Grafana instances..."
	@if command -v open > /dev/null; then \
		open http://localhost:3000; \
		open http://localhost:3001; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3000; \
		xdg-open http://localhost:3001; \
	else \
		echo "Please open http://localhost:3000 and http://localhost:3001 in your browser"; \
	fi

open-us:
	@echo "Opening US Region Grafana..."
	@if command -v open > /dev/null; then \
		open http://localhost:3000; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3000; \
	else \
		echo "Please open http://localhost:3000 in your browser"; \
	fi

open-eu:
	@echo "Opening EU Region Grafana..."
	@if command -v open > /dev/null; then \
		open http://localhost:3001; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3001; \
	else \
		echo "Please open http://localhost:3001 in your browser"; \
	fi

open-all:
	@echo "Opening all interfaces..."
	@if command -v open > /dev/null; then \
		open http://localhost:3000; \
		open http://localhost:3001; \
		open http://localhost:4040; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3000; \
		xdg-open http://localhost:3001; \
		xdg-open http://localhost:4040; \
	else \
		echo "Please open http://localhost:3000, http://localhost:3001, and http://localhost:4040 in your browser"; \
	fi

ngrok-url:
	@echo "Fetching ngrok public URL..."
	@curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | grep -o 'https://[^"]*' || echo "Ngrok not running or URL not available"

clean: ## Stop and remove all containers, volumes, and networks
	@echo "Cleaning up Git Sync repositories..."
	@grafanactl --config=grafanactl.yaml config use-context us 2>/dev/null || true
	@grafanactl --config=grafanactl.yaml resources delete repositories --force 2>/dev/null || echo "No US repositories to clean or Grafana not running"
	@grafanactl --config=grafanactl.yaml config use-context eu 2>/dev/null || true
	@grafanactl --config=grafanactl.yaml resources delete repositories --force 2>/dev/null || echo "No EU repositories to clean or Grafana not running"
	@echo "Stopping and removing containers..."
	docker-compose --env-file ../.env down -v
	@echo "All resources cleaned up"
