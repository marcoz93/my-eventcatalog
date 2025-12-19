# Build stage
FROM node:20 AS builder
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=4096"
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage - nginx
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
