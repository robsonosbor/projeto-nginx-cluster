.PHONY: help build up down logs restart clean test ps

# Cores para output
CYAN := \033[0;36m
GREEN := \033[0;32m
YELLOW := \033[0;33m
RED := \033[0;31m
NC := \033[0m # No Color

help: ## Mostra este help
	@echo "$(CYAN)=== Projeto Nginx Cluster ===$(NC)"
	@echo ""
	@echo "$(YELLOW)Comandos Disponíveis:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Build das imagens Docker
	@echo "$(CYAN)Building Docker images...$(NC)"
	docker-compose build

up: ## Inicia todos os serviços
	@echo "$(CYAN)Starting services...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)✓ Serviços iniciados$(NC)"
	@echo "$(YELLOW)Acesse: http://localhost:4500$(NC)"

down: ## Para todos os serviços
	@echo "$(CYAN)Stopping services...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ Serviços parados$(NC)"

restart: ## Reinicia todos os serviços
	@echo "$(CYAN)Restarting services...$(NC)"
	docker-compose restart
	@echo "$(GREEN)✓ Serviços reiniciados$(NC)"

logs: ## Mostra logs de todos os serviços
	docker-compose logs -f

logs-nginx: ## Mostra logs do Nginx
	docker-compose logs -f nginx

logs-php: ## Mostra logs do PHP-FPM
	docker-compose logs -f php-fpm-1

logs-mysql: ## Mostra logs do MySQL
	docker-compose logs -f mysql

ps: ## Lista status dos containers
	@echo "$(CYAN)Container Status:$(NC)"
	docker-compose ps

clean: ## Remove containers, networks e volumes
	@echo "$(RED)Removing containers, networks and volumes...$(NC)"
	docker-compose down -v
	@echo "$(GREEN)✓ Limpeza completa realizada$(NC)"

test: ## Testa a aplicação
	@echo "$(CYAN)Testing application...$(NC)"
	@curl -s http://localhost:4500 | head -20
	@echo "$(GREEN)✓ Teste concluído$(NC)"

shell-nginx: ## Abre shell no Nginx
	docker-compose exec nginx sh

shell-php: ## Abre shell no PHP-FPM
	docker-compose exec php-fpm-1 sh

shell-mysql: ## Abre shell no MySQL
	docker-compose exec mysql bash

mysql-cli: ## Acessa MySQL CLI
	docker-compose exec mysql mysql -u root -pSenha123 meubanco

stats: ## Mostra estatísticas de containers
	docker stats

health-check: ## Verifica health dos containers
	@echo "$(CYAN)Health Check:$(NC)"
	@docker inspect nginx-lb | grep -A 5 "Health"

rebuild: down build up ## Rebuild completo (down + build + up)
	@echo "$(GREEN)✓ Rebuild completo realizado$(NC)"

validate: ## Valida configurações
	@echo "$(CYAN)Validating Nginx configuration...$(NC)"
	docker-compose exec nginx nginx -t
	@echo "$(GREEN)✓ Configuração Nginx válida$(NC)"

version: ## Mostra versões dos serviços
	@echo "$(CYAN)=== Versões ===$(NC)"
	@echo "$(YELLOW)Nginx:$(NC)"
	@docker-compose exec nginx nginx -v
	@echo "$(YELLOW)PHP:$(NC)"
	@docker-compose exec php-fpm-1 php -v | head -1
	@echo "$(YELLOW)MySQL:$(NC)"
	@docker-compose exec mysql mysql --version

.DEFAULT_GOAL := help
