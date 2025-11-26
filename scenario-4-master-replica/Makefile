.PHONY: help start stop restart logs logs-master logs-replica logs-lb status health open open-master open-replica open-lb open-all ngrok-url failover-to-master failover-to-replica clean

help:
	@echo "Available commands:"
	@echo "  make start              - Start master, replica, and load balancer"
	@echo "  make stop               - Stop all services"
	@echo "  make restart            - Restart all services"
	@echo "  make logs               - View logs from all services"
	@echo "  make logs-master        - View logs from master"
	@echo "  make logs-replica       - View logs from replica"
	@echo "  make logs-lb            - View logs from load balancer"
	@echo "  make status             - Show container status"
	@echo "  make health             - Check health of all services"
	@echo "  make open               - Open load balancer in browser"
	@echo "  make open-master        - Open master Grafana"
	@echo "  make open-replica       - Open replica Grafana"
	@echo "  make open-lb            - Open load balancer"
	@echo "  make open-all           - Open all interfaces"
	@echo "  make ngrok-url          - Get public ngrok URL"
	@echo "  make failover-to-master - Failover ngrok to master"
	@echo "  make failover-to-replica- Failover ngrok to replica"
	@echo "  make clean              - Stop and remove all containers and volumes"

start:
	docker-compose up -d
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
	@echo "Get public URL:        make ngrok-url"
	@echo "Failover to replica:   make failover-to-replica"
	@echo "Failover to master:    make failover-to-master"

stop:
	docker-compose down

restart: stop start

logs:
	docker-compose logs -f

logs-master:
	docker-compose logs -f grafana-master

logs-replica:
	docker-compose logs -f grafana-replica

logs-lb:
	docker-compose logs -f nginx

status:
	docker-compose ps

health:
	@echo "Checking service health..."
	@docker-compose ps
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
	@docker-compose stop ngrok
	@docker-compose rm -f ngrok
	@sed -i.bak 's/command: http --url=$${NGROK_SUBDOMAIN} grafana-replica:3000/command: http --url=$${NGROK_SUBDOMAIN} grafana-master:3000/' docker-compose.yml
	@docker-compose up -d ngrok
	@echo "Ngrok now points to master"
	@echo "New URL:"
	@sleep 2
	@make ngrok-url

failover-to-replica:
	@echo "Performing failover to replica..."
	@docker-compose stop ngrok
	@docker-compose rm -f ngrok
	@sed -i.bak 's/command: http --url=$${NGROK_SUBDOMAIN} grafana-master:3000/command: http --url=$${NGROK_SUBDOMAIN} grafana-replica:3000/' docker-compose.yml
	@docker-compose up -d ngrok
	@echo "Ngrok now points to replica"
	@echo "New URL:"
	@sleep 2
	@make ngrok-url

clean:
	docker-compose down -v
	rm -f docker-compose.yml.bak
	@echo "All containers and volumes removed"
