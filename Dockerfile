# Build stage - usar node normal (não alpine) para ter bash
FROM node:20 AS builder
WORKDIR /app

# Aumentar memória para o build
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Copiar arquivos de dependência
COPY package*.json ./
RUN npm install

# Copiar resto do projeto
COPY . .

# Build
RUN npm run build

# Production stage - servir arquivos estáticos
FROM node:20-alpine AS runner
WORKDIR /app

# Instalar servidor HTTP simples
RUN npm install -g serve

# Copiar arquivos buildados
COPY --from=builder /app/dist ./dist

EXPOSE 3000

# Servir arquivos estáticos
CMD ["serve", "dist", "-l", "3000", "-s"]
