# Use imagem Alpine para reduzir tamanho
FROM nginx:latest-alpine3.19

# Metadados
LABEL maintainer="seu-email@exemplo.com"
LABEL description="Nginx Load Balancer para cluster de microsserviços"
LABEL version="1.0"

# Definir variáveis de ambiente
ENV NGINX_VERSION=1.25 \
    TZ=America/Sao_Paulo

# Copiar arquivos de configuração
COPY nginx.conf /etc/nginx/nginx.conf

# Criar diretório para logs
RUN mkdir -p /var/log/nginx && chmod 755 /var/log/nginx

# Expor porta
EXPOSE 4500

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -q --spider http://localhost:4500/health || exit 1

# Executar Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]