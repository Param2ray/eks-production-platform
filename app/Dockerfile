# Stage 1: Build

FROM alpine:3.20 AS builder

WORKDIR /app

COPY . .

# Stage 2: Runtime

FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY --from=builder /app /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]