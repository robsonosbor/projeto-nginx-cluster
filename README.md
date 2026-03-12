# Projeto Nginx Cluster

> Demonstração prática de um cluster load balancer com Nginx, PHP e MySQL em containers Docker

##  Descrição

Este projeto implementa uma arquitetura de **microsserviços com load balancing**, utilizando Docker para orquestração de containers. Demonstra como configurar um balanceador de carga Nginx para distribuir requisições entre múltiplos servidores backend, gerenciados em um cluster containerizado.

A solução inclui:
- 🔄 Balanceador de carga Nginx com round-robin
- 🐘 Aplicação PHP para backend
- 🗄️ Banco de dados MySQL
- 🐳 Containerização completa com Docker

##  Objetivo

Exemplificar a utilização prática do Docker em um cenário de **arquitetura de microsserviços**, demostrando:
- Containerização de aplicações
- Configuração de load balancing
- Comunicação entre containers
- Persistência de dados

##  Tecnologias Utilizadas

- **Docker** - Containerização
- **Nginx** - Servidor web e load balancer
- **PHP** - Backend (aplicação)
- **MySQL** - Banco de dados
- **Linux** - Sistema operacional

##  Estrutura do Projeto

```
projeto-nginx-cluster/
├── app/
│   └── index.php           # Aplicação PHP backend
├── dockerfile              # Imagem Docker com Nginx
├── docker-compose.yml      # Orquestração dos containers
├── nginx.conf              # Configuração do load balancer
├── banco.sql               # Schema do banco de dados
├── .env.configuration      # Variáveis de exemplo
└── README.md              # Este arquivo
```

##  Componentes

### Dockerfile
Cria uma imagem Docker baseada em Nginx com configuração customizada para funcionar como load balancer.

### nginx.conf
Configura o Nginx para:
- Escutar na porta `4500`
- Distribuir requisições entre 3 servidores upstream (IPs: 172.31.0.37, 172.31.0.151, 172.31.0.149)
- Usar algoritmo round-robin para balanceamento

### index.php
Aplicação PHP que:
- Conecta-se ao banco de dados MySQL
- Insere registros com dados aleatórios
- Exibe a versão do PHP e nome do host

### banco.sql
Define a tabela `dados` com campos para armazenar informações:
- AlunoID, Nome, Sobrenome, Endereco, Cidade, Host

##  Pré-requisitos

- Docker instalado ([Download](https://www.docker.com/get-started))
- Docker Compose (opcional)
- Conhecimentos básicos em:
  - Linux/Shell
  - Docker e containers
  - Networking

##  Como Usar

### Pré-requisito: Arquivo .env
Copie o arquivo `.env.configuration` para `.env` e configure as variáveis:

```bash
cp .env.configuration .env
```

Edite `.env` com suas credenciais:
```
DB_HOST=mysql
DB_USER=root
DB_PASS=Senha123
DB_NAME=meubanco
```

### 1. Build e Start com Docker Compose

```bash
# Build das imagens
docker-compose build

# Iniciar todos os serviços
docker-compose up -d

# Verificar status
docker-compose ps
```

### 2. Acessar a Aplicação

```
http://localhost:4500
```

### 3. Verificar Logs

```bash
# Logs do Nginx
docker-compose logs -f nginx

# Logs do PHP-FPM
docker-compose logs -f php-fpm-1

# Logs do MySQL
docker-compose logs -f mysql
```

### 4. Testar Load Balancer

```bash
# Fazer múltiplas requisições (cada uma vai para um container diferente)
for i in {1..10}; do curl http://localhost:4500; done
```

### 5. Acessar o Banco de Dados

```bash
# Via docker-compose
docker-compose exec mysql mysql -u root -p meubanco

# Ou diretamente
mysql -h 127.0.0.1 -u root -p meubanco
```

### 6. Parar os Serviços

```bash
# Parar
docker-compose down

# Parar e remover volumes (cuidado!)
docker-compose down -v
```

##  Serviços Inclusos

## � Serviços Inclusos

| Serviço | Container | Porta | Descrição |
|---------|-----------|-------|-----------|
| **Nginx** | nginx-lb | 4500 | Load balancer |
| **PHP-FPM 1** | php-fpm-1 | 9000 | Backend #1 |
| **PHP-FPM 2** | php-fpm-2 | 9000 | Backend #2 |
| **PHP-FPM 3** | php-fpm-3 | 9000 | Backend #3 |
| **MySQL** | mysql-db | 3306 | Banco de dados |

## 🌐 Endpoints

- **Aplicação**: `http://localhost:4500`
- **Health Check**: `http://localhost:4500/health`
- **Métricas Nginx**: `http://localhost:4500/metrics`
- **MySQL**: `localhost:3306` (dentro da rede: `mysql:3306`)

##  Configuração

### Variáveis de Ambiente
Edite o arquivo `.env` para personalizar:

```env
DB_HOST=mysql              # Host do MySQL (dentro da rede Docker)
DB_USER=root              # Usuário MySQL
DB_PASS=Senha123          # Senha MySQL
DB_NAME=meubanco          # Nome do banco de dados
```

### Modificar Número de Replicas
Edite `docker-compose.yml` para aumentar/diminuir containers:

```yaml
php-fpm-4:  # Novo container
  image: php:8.2-fpm-alpine
  # ... configuração igual aos outros
```

E adicione no upstream do `nginx.conf`:
```nginx
upstream php_fpm {
    server php-fpm-4:9000;  # Novo servidor
    ...
}
```

### Customizar Configuração Nginx
Edite `nginx.conf` e recarregue:

```bash
docker-compose exec nginx nginx -s reload
```

### Alterar Porta de Escuta
Em `docker-compose.yml`:
```yaml
nginx:
  ports:
    - "8080:4500"  # Mapeia localhost:8080 para container:4500
```

##  Solução de Problemas

### Container não inicia
```bash
# Verifique logs
docker-compose logs nginx
docker-compose logs mysql

# Verifique se alguma porta está em uso
netstat -an | findstr 4500
```

### Conexão recusada no PHP
- Certifique-se de que MySQL iniciou: `docker-compose logs mysql`
- Verifique credenciais no `.env`
- Teste conectividade: `docker-compose exec php-fpm-1 ping mysql`

### Nginx não encontra PHP-FPM
- Verifique se PHP-FPM está rodando: `docker-compose ps`
- Valide sintaxe: `docker-compose exec nginx nginx -t`
- Reinicie: `docker-compose restart`

### Permissão negada em volumes
```bash
# No Linux, pode ser necessário:
sudo chown -R www-data:www-data app/
```

### Limpar e recomeçar
```bash
# Remove tudo (containers, volumes, networks)
docker-compose down -v

# Rebuild e restart
docker-compose up -d --build
```

##  Monitoramento

### Health Check Status
```bash
# Verifique saúde dos containers
docker-compose ps

# Health check detalhado
docker inspect nginx-lb | grep -A 10 "Health"
```

### Métricas Nginx
```bash
# Acesse o endpoint de métricas
curl http://localhost:4500/metrics
```

### Visualizar Logs em Tempo Real
```bash
# Todos os logs
docker-compose logs -f

# Filtrar por serviço
docker-compose logs -f nginx
docker-compose logs -f mysql
```

### Estatísticas de Uso
```bash
# CPU, memória e I/O
docker stats

# Tamanho dos containers
docker-compose exec mysql du -sh /var/lib/mysql
```

##  Referências

- [Documentação Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Documentação Nginx](https://nginx.org/en/docs/)
- [PHP PDO](https://www.php.net/manual/en/book.pdo.php)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)

##  Créditos

Baseado em conteúdo educacional sobre Docker e microsserviços.

##  Licença

Este projeto é fornecido como material educacional.

##  Dúvidas e Contribuições

Para dúvidas ou sugestões, abra uma **Issue** ou envie um **Pull Request**.

---

**Última atualização**: Março de 2026
