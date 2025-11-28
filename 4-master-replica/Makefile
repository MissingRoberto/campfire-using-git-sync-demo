.PHONY: help start stop restart logs logs-master logs-replica logs-lb status health open open-master open-replica open-lb open-ngrok open-all ngrok-url failover-to-master failover-to-replica clean setup-git-sync

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
	@echo "  make open-master         - Open master Grafana (localhost:3000)"
	@echo "  make open-replica        - Open replica Grafana (localhost:3001)"
	@echo "  make open-lb             - Open nginx load balancer (localhost:8080)"
	@echo "  make open-ngrok          - Open public ngrok URL"
	@echo "  make open-all            - Open all interfaces"
	@echo "  make ngrok-url           - Get public ngrok URL"
	@echo "  make failover-to-master  - Failover ngrok to master"
	@echo "  make failover-to-replica - Failover ngrok to replica"
	@echo "  make clean               - Stop and remove all containers and volumes"
	@echo ""
	@echo "Architecture:"
	@echo "  - Master & Replica: Two Grafana instances with Git Sync"
	@echo "  - Nginx (port 8080): Local load balancer with automatic failover"
	@echo "  - Ngrok: Public internet access to either master OR replica (manual failover)"

start:
	docker-compose --env-file ../.env up -d
	@echo "Waiting for services to be healthy..."
	@sleep 5
	@echo ""
	@echo "Services started!"
	@echo "Master:             http://localhost:3000"
	@echo "Replica:            http://localhost:3001"
	@echo "Nginx Load Balancer: http://localhost:8080 (auto-failover)"
	@echo ""
	@echo "Login: admin / admin"
	@echo ""
	@echo "Next step:"
	@echo "  make setup-git-sync       - Configure Git Sync for both instances"
	@echo ""
	@echo "Public access:"
	@echo "  make ngrok-url            - Get public ngrok URL"
	@echo "  make open-ngrok           - Open public URL in browser"
	@echo ""
	@echo "Ngrok failover (manual):"
	@echo "  make failover-to-master   - Switch ngrok to master"
	@echo "  make failover-to-replica  - Switch ngrok to replica"

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

open-ngrok:
	@echo "Opening public ngrok URL..."
	@URL=$$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*"' | head -1 | cut -d'"' -f4); \
	if [ -z "$$URL" ]; then \
		echo "Error: Could not get ngrok URL. Is ngrok running?"; \
		exit 1; \
	fi; \
	echo "Opening $$URL"; \
	if command -v open > /dev/null; then \
		open "$$URL"; \
	elif command -v xdg-open > /dev/null; then \
		xdg-open "$$URL"; \
	else \
		echo "Please open $$URL in your browser"; \
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
	@echo "Public ngrok URL:"
	@URL=$$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*"' | head -1 | cut -d'"' -f4); \
	if [ -z "$$URL" ]; then \
		echo "Error: Ngrok not running or URL not available"; \
	else \
		echo "$$URL"; \
		CURRENT=$$(docker inspect ngrok-lb 2>/dev/null | grep -o 'grafana-[^:]*' | head -1); \
		if [ -n "$$CURRENT" ]; then \
			echo "Currently pointing to: $$CURRENT"; \
		fi; \
	fi

failover-to-master:
	@if grep -q "grafana-master:3000" docker-compose.yml; then \
		echo "Already pointing to master - no change needed"; \
		echo ""; \
		make ngrok-url; \
	else \
		echo "Performing failover to master..."; \
		docker-compose --env-file ../.env stop ngrok >/dev/null 2>&1; \
		docker-compose --env-file ../.env rm -f ngrok >/dev/null 2>&1; \
		sed -i.bak 's/grafana-replica:3000/grafana-master:3000/' docker-compose.yml; \
		echo "Switched from replica to master"; \
		docker-compose --env-file ../.env up -d ngrok >/dev/null 2>&1; \
		echo "Waiting for ngrok to start..."; \
		sleep 3; \
		echo ""; \
		make ngrok-url; \
	fi

failover-to-replica:
	@if grep -q "grafana-replica:3000" docker-compose.yml; then \
		echo "Already pointing to replica - no change needed"; \
		echo ""; \
		make ngrok-url; \
	else \
		echo "Performing failover to replica..."; \
		docker-compose --env-file ../.env stop ngrok >/dev/null 2>&1; \
		docker-compose --env-file ../.env rm -f ngrok >/dev/null 2>&1; \
		sed -i.bak 's/grafana-master:3000/grafana-replica:3000/' docker-compose.yml; \
		echo "Switched from master to replica"; \
		docker-compose --env-file ../.env up -d ngrok >/dev/null 2>&1; \
		echo "Waiting for ngrok to start..."; \
		sleep 3; \
		echo ""; \
		make ngrok-url; \
	fi

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
