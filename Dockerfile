FROM node:17-alpine3.15 AS builder

WORKDIR /app

# copy files and install dependencies
COPY . ./
RUN npm install
RUN npm run build

FROM nginx:1.21.6-alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/public .
