# 🚀 Quick Start Guide

## 30 segundos para rodar o projeto

### 1️⃣ Preparação
```bash
cp .env.configuration .env
```

### 2️⃣ Build e Deploy
```bash
docker-compose up -d --build
```

### 3️⃣ Acessar
```
http://localhost:4500
```

---

## Comandos Úteis

```bash
# Logs
docker-compose logs -f

# Status
docker-compose ps

# Parar
docker-compose down

# Com Makefile (melhor!)
make up      # Inicia
make logs    # Logs
make test    # Testa
make down    # Para
```

---

## 📚 Documentação

- **README.md** - Documentação principal
- **TECHNICAL.md** - Guia técnico detalhado
- **CONTRIBUTING.md** - Como contribuir
- **IMPLEMENTATION.md** - Relatório de implementação

---

## ⚡ Features

✅ Load Balancing (Nginx)  
✅ 3 Servidores PHP-FPM  
✅ MySQL com persistência  
✅ Health Checks  
✅ Security Headers  
✅ Compressão Gzip  
✅ Logging estruturado  

---

## 🔧 Troubleshooting

**Porta 4500 em uso?**
```bash
docker-compose down -v
# Espere 10s e tente novamente
docker-compose up -d
```

**Erro de conexão MySQL?**
```bash
docker-compose logs mysql
# Aguarde inicialização
```

**Alterar credenciais?**
```bash
# Edite .env e execute
docker-compose down -v
docker-compose up -d --build
```

---

**Pronto! Seu projeto está rodando.** 🎉
