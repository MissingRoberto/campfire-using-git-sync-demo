.PHONY: help start stop restart logs logs-master logs-replica logs-lb status health open open-master open-replica open-lb open-all ngrok-url failover-to-master failover-to-replica clean setup-git-sync

help:
	@echo "Available commands:"
	@echo "  make start               - Start master, replica, and load balancer"
	@echo "  make setup-git-sync      - Configure Git Sync for master and replica"
	@echo "  make stop                - Stop all services"
	@echo "  make restart             - Restart all services"
	@echo "  make logs                - View logs from all services"
	@echo "  make logs-master         - View logs from master"
	@echo "  make logs-replica        - View logs from replica"
	@echo "  make logs-lb             - View logs from load balancer"
	@echo "  make status              - Show container status"
	@echo "  make health              - Check health of all services"
	@echo "  make open                - Open load balancer in browser"
	@echo "  make open-master         - Open master Grafana"
	@echo "  make open-replica        - Open replica Grafana"
	@echo "  make open-lb             - Open load balancer"
	@echo "  make open-all            - Open all interfaces"
	@echo "  make ngrok-url           - Get public ngrok URL"
	@echo "  make failover-to-master  - Failover ngrok to master"
	@echo "  make failover-to-replica - Failover ngrok to replica"
	@echo "  make clean               - Stop and remove all containers and volumes"

start:
	docker-compose --env-file ../.env up -d
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@echo ""
	@echo "Services started!"
	@echo "Master:        http://localhost:3000"
	@echo "Replica:       http://localhost:3001"
	@echo "Load Balancer: http://localhost:8080"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Next step:"
	@echo "  make setup-git-sync      - Configure Git Sync for both instances"
	@echo ""
	@echo "Get public URL:        make ngrok-url"
	@echo "Failover to replica:   make failover-to-replica"
	@echo "Failover to master:    make failover-to-master"

setup-git-sync: ## Configure Git Sync repositories for master and replica
	@echo "Configuring Git Sync..."
	@../scripts/setup-git-sync.sh 4-master-replica master repository-master.yaml replica repository-replica.yaml
	@echo ""
	@echo "Master:  http://localhost:3000 - syncing from 4-master-replica/shared"
	@echo "Replica: http://localhost:3001 - syncing from 4-master-replica/shared"
	@echo "Load Balancer: http://localhost:8080"

stop:
	docker-compose --env-file ../.env down

restart: stop start

logs:
	docker-compose --env-file ../.env logs -f

logs-master:
	docker-compose --env-file ../.env logs -f grafana-master

logs-replica:
	docker-compose --env-file ../.env logs -f grafana-replica

logs-lb:
	docker-compose --env-file ../.env logs -f nginx

status:
	docker-compose --env-file ../.env ps

health:
	@echo "Checking service health..."
	@docker-compose --env-file ../.env ps
	@echo ""
	@echo "Master Health:"
	@curl -s http://localhost:3000/api/health | grep -q "ok" && echo "✓ Master is healthy" || echo "✗ Master is not responding"
	@echo "Replica Health:"
	@curl -s http://localhost:3001/api/health | grep -q "ok" && echo "✓ Replica is healthy" || echo "✗ Replica is not responding"
	@echo "Load Balancer Health:"
	@curl -s http://localhost:8080/api/health | grep -q "ok" && echo "✓ Load Balancer is healthy" || echo "✗ Load Balancer is not responding"

open:
	@echo "Opening load balancer..."
	@if command -v open > /dev/null; then \
		open http://localhost:8080; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:8080; \
	else \
		echo "Please open http://localhost:8080 in your browser"; \
	fi

open-master:
	@echo "Opening Master Grafana..."
	@if command -v open > /dev/null; then \
		open http://localhost:3000; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3000; \
	else \
		echo "Please open http://localhost:3000 in your browser"; \
	fi

open-replica:
	@echo "Opening Replica Grafana..."
	@if command -v open > /dev/null; then \
		open http://localhost:3001; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3001; \
	else \
		echo "Please open http://localhost:3001 in your browser"; \
	fi

open-lb:
	@echo "Opening Load Balancer..."
	@if command -v open > /dev/null; then \
		open http://localhost:8080; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:8080; \
	else \
		echo "Please open http://localhost:8080 in your browser"; \
	fi

open-all:
	@echo "Opening all interfaces..."
	@if command -v open > /dev/null; then \
		open http://localhost:3000; \
		open http://localhost:3001; \
		open http://localhost:8080; \
		open http://localhost:4040; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open http://localhost:3000; \
		xdg-open http://localhost:3001; \
		xdg-open http://localhost:8080; \
		xdg-open http://localhost:4040; \
	else \
		echo "Please open http://localhost:3000, http://localhost:3001, http://localhost:8080, and http://localhost:4040 in your browser"; \
	fi

ngrok-url:
	@echo "Fetching ngrok public URL..."
	@curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | grep -o 'https://[^"]*' || echo "Ngrok not running or URL not available"

failover-to-master:
	@echo "Performing failover to master..."
	@docker-compose --env-file ../.env stop ngrok
	@docker-compose --env-file ../.env rm -f ngrok
	@sed -i.bak 's/grafana-replica:3000/grafana-master:3000/' docker-compose.yml
	@docker-compose --env-file ../.env up -d ngrok
	@echo "Ngrok now points to master"
	@echo "URL:"
	@sleep 2
	@make ngrok-url

failover-to-replica:
	@echo "Performing failover to replica..."
	@docker-compose --env-file ../.env stop ngrok
	@docker-compose --env-file ../.env rm -f ngrok
	@sed -i.bak 's/grafana-master:3000/grafana-replica:3000/' docker-compose.yml
	@docker-compose --env-file ../.env up -d ngrok
	@echo "Ngrok now points to replica"
	@echo "URL:"
	@sleep 2
	@make ngrok-url

clean: ## Stop and remove all containers, volumes, and networks
	@echo "Cleaning up Git Sync repositories..."
	@grafanactl --config=grafanactl.yaml config use-context master 2>/dev/null || true
	@grafanactl --config=grafanactl.yaml resources delete repositories --force 2>/dev/null || echo "No master repositories to clean or Grafana not running"
	@grafanactl --config=grafanactl.yaml config use-context replica 2>/dev/null || true
	@grafanactl --config=grafanactl.yaml resources delete repositories --force 2>/dev/null || echo "No replica repositories to clean or Grafana not running"
	@echo "Stopping and removing containers..."
	docker-compose --env-file ../.env down -v
	rm -f docker-compose.yml.bak
	@echo "All resources cleaned up"
