# Stage 1: Build
FROM node:22-alpine AS build
WORKDIR /app

# Copy dependency files first (leverages Docker cache)
COPY package.json package-lock.json ./
RUN npm ci --loglevel=verbose 2>&1

# Copy source and build
COPY . .
RUN npm run build 2>&1 && echo "BUILD SUCCESS" || (echo "BUILD FAILED" && exit 1)

# Stage 2: Serve with nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
RUN ls -la /usr/share/nginx/html/ && echo "FILES COPIED"
EXPOSE 80
