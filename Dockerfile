# ---- Build Stage ----
# Use a Node.js version compatible with the project requirements (Node 8.17.0 specified in README)
# Using a slightly newer LTS version for better support, adjust if needed.
FROM node:8-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
# Using --legacy-peer-deps might be necessary for older projects
RUN apk add --no-cache python2 make g++

# Copy the rest of the application source code
COPY . .

# Build the application
# The build output will be in the /app/dist directory (based on config/index.js)
RUN npm run build

# ---- Production Stage ----
# Use a lightweight Nginx image
FROM nginx:stable-alpine AS production-stage

# Copy the built static files from the builder stage to the Nginx HTML directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy the custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port Nginx will listen on (defined in nginx.conf)
EXPOSE 8080

# Default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
